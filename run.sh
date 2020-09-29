
PROFILE=...
export BUCKET=...
REGION=us-east-1
KEYPAIR=ec2-keypair

# https://cloud-images.ubuntu.com/locator/ec2/  # amd64 us-east-1 ebs-ssd hvm
IMAGEID=ami-013da1cc4ae87618c


export BENCHMARK="$1"

# https://stackoverflow.com/questions/2427995/bash-no-arguments-warning-and-case-decisions
if [[ $# -eq 0 ]]; then BENCHMARK="countbits"; fi

case "$BENCHMARK" in
    # https://unix.stackexchange.com/questions/62333/setting-a-shell-variable-in-a-null-coalescing-fashion
    fibonacci) export ARGS="${2:-42}" ;;
    *) ;;
esac

# http://docs.aws.amazon.com/cli/latest/userguide/controlling-output.html#controlling-output-filter
SGID=$(aws ec2 describe-security-groups \
    --profile $PROFILE \
    --region $REGION \
    --query 'SecurityGroups[?GroupName==`ssh-anywhere`].GroupId' \
    --output text)
echo $SGID

echo $PROFILE $REGION $BUCKET $TYPE $KEYPAIR $IMAGEID $SGID

NOW=`date +%Y%m%d%H%M%S`

# https://www.cyberciti.biz/faq/bash-for-loop-array/
types=( c csharp elixir go java java_1 java_2 jruby javascript javascript_1 javascript_2 php python3 ruby rust )

for TYPE in "${types[@]}"
do
    export TYPE
    # https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
    export LANG=${TYPE%%_*}

    # https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
    if [ ! -d "$BENCHMARK/$TYPE" ]; then
        continue
    fi

    echo ""

    echo "aws s3 ls --profile $PROFILE $BUCKET/$TYPE/"
    aws s3 ls --profile $PROFILE $BUCKET/$TYPE/

    # https://superuser.com/questions/133780/in-bash-how-do-i-escape-an-exclamation-mark
    # https://stackoverflow.com/questions/10683349/forcing-bash-to-expand-variables-in-a-string-loaded-from-a-file
    USERDATA=$(
        echo -e "#"'!'"/bin/bash\n"
        echo -e "\n# ----- CLONE -----\n"
        cat clone_repo.sh
        echo -e "\n# ----- SETUP -----\n"
        cat setup/$LANG/setup.sh
        echo -e "\n# ----- BUILD -----\n"
        echo -e "cd countbits/$BENCHMARK/$TYPE && . ./build.sh\n"
        echo -e "\n# ----- RUN AND COPY -----\n"
        envsubst \$BUCKET,\$BENCHMARK,\$TYPE,\$ARGS < benchmark_type.sh
    )

    INSTANCEID=$(aws ec2 run-instances \
        --profile $PROFILE \
        --region $REGION \
        --output text \
        --query 'Instances[*].InstanceId' \
        --image-id $IMAGEID \
        --key-name $KEYPAIR \
        --security-group-ids $SGID \
        --instance-type t2.micro \
        --user-data "$USERDATA" \
        --instance-initiated-shutdown-behavior terminate \
        --iam-instance-profile Name="s3-put-profile" \
        --count 1)
    echo "aws ec2 terminate-instances --profile $PROFILE --region $REGION --instance-ids $INSTANCEID"


    aws ec2 create-tags \
        --profile $PROFILE \
        --region $REGION \
        --resources $INSTANCEID \
        --tags Key=Name,Value="$BENCHMARK $TYPE $NOW"

    DOMAIN=$(aws ec2 describe-instances \
        --profile $PROFILE \
        --region $REGION \
        --instance-ids $INSTANCEID \
        --output text \
        --query 'Reservations[*].Instances[*].PublicDnsName')
    echo "ssh -i ~/.ssh/$KEYPAIR.pem ubuntu@$DOMAIN"
done


unset ARGS  # in case it was set for fibonacci

echo ""
echo "aws ec2 describe-instances --profile $PROFILE --region $REGION --query 'Reservations[*].Instances[*].[LaunchTime, InstanceId, State.Name, Tags[0].Value]' --output text"

aws ec2 describe-instances \
    --profile $PROFILE \
    --region $REGION \
    --query 'Reservations[*].Instances[*].[LaunchTime, InstanceId, State.Name, Tags[0].Value]' \
    --output text
