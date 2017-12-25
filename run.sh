
PROFILE=...
REGION=us-east-1
KEYPAIR=ec2-keypair
BUCKET=...

# https://cloud-images.ubuntu.com/locator/ec2/  # 64 us-east-1 ebs hvm
IMAGEID=ami-3dec9947

# http://docs.aws.amazon.com/cli/latest/userguide/controlling-output.html#controlling-output-filter
SGID=$(aws ec2 describe-security-groups \
    --profile $PROFILE \
    --region $REGION \
    --query 'SecurityGroups[?GroupName==`ssh-anywhere`].GroupId' \
    --output text)
echo $SGID

echo $PROFILE $REGION $BUCKET $TYPE $KEYPAIR $IMAGEID $SGID


# https://www.cyberciti.biz/faq/bash-for-loop-array/
types=( c cs go java1 java2 jruby js1 js2 php python ruby )
# cpp elixir rust

for TYPE in "${types[@]}"
do
    echo "aws s3 ls --profile $PROFILE $BUCKET/$TYPE/"
    aws s3 ls --profile $PROFILE $BUCKET/$TYPE/

    INSTANCEID=$(aws ec2 run-instances \
        --profile $PROFILE \
        --region $REGION \
        --output text \
        --query 'Instances[*].InstanceId' \
        --image-id $IMAGEID \
        --key-name $KEYPAIR \
        --security-group-ids $SGID \
        --instance-type t2.micro \
        --user-data file://./$TYPE/run.sh \
        --instance-initiated-shutdown-behavior terminate \
        --iam-instance-profile Name="s3-put-profile" \
        --count 1)
    echo "aws ec2 terminate-instances --profile $PROFILE --region $REGION --instance-ids $INSTANCEID"


    aws ec2 create-tags \
        --profile $PROFILE \
        --region $REGION \
        --resources $INSTANCEID \
        --tags Key=Name,Value="countbits $TYPE"

    DOMAIN=$(aws ec2 describe-instances \
        --profile $PROFILE \
        --region $REGION \
        --instance-ids $INSTANCEID \
        --output text \
        --query 'Reservations[*].Instances[*].PublicDnsName')
    echo "ssh -i ~/.ssh/$KEYPAIR.pem ubuntu@$DOMAIN"
done

echo "aws ec2 describe-instances --profile $PROFILE --region $REGION --query 'Reservations[*].Instances[*].[LaunchTime, InstanceId, State.Name, Tags[0].Value]' --output text"

aws ec2 describe-instances --profile $PROFILE --region $REGION --query 'Reservations[*].Instances[*].[LaunchTime, InstanceId, State.Name, Tags[0].Value]' --output text

