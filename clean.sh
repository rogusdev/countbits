
PROFILE=...
REGION=us-east-1
KEYPAIR=ec2-keypair
BUCKET=...

# https://cloud-images.ubuntu.com/locator/ec2/  # 64 us-east-1 ebs hvm
IMAGEID=ami-41e0b93b

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
    echo "$TYPE s3 bucket:"
    aws s3 ls --profile $PROFILE $BUCKET/$TYPE/

    # https://stackoverflow.com/questions/36813327/how-to-display-only-files-from-aws-s3-ls-command
    files=(`aws s3 ls --profile $PROFILE $BUCKET/$TYPE/ | awk '{print $4}'`)

    for file in "${files[@]}"
    do
        if [[ $file =~ output_.*\.json ]]; then
            aws s3 cp --profile $PROFILE s3://$BUCKET/$TYPE/$file ./${TYPE}_${file}
            aws s3 rm --profile $PROFILE s3://$BUCKET/$TYPE/$file
        elif [[ $file = cloud-init-output.log ]]; then
            aws s3 cp --profile $PROFILE s3://$BUCKET/$TYPE/$file ./${TYPE}-$file
            aws s3 rm --profile $PROFILE s3://$BUCKET/$TYPE/$file
        fi
    done
done

