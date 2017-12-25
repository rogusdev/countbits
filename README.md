countbits
=========

exploring the speed of varying languages at counting "on" bits in integers

Runs ec2 instances for each test and outputs results to s3

This is based on an interview question I encountered where the interviewer asked me
how I would count "on" bits in an integer, given repeated unpredictable requests (i.e. a service)
and I suggested a lookup table, and he *scoffed* that this would be even remotely feasible.
Told me that even if it could fit (uhh, 32 bits is 4 gb?) it would take too long to generate.
(He wanted me to propose a caching scheme.  I did not pursue the job.)

So, let's see how long it does take to generate ;)


Current stats, per 10mm:
- C ~1.0s
- C# dotnet core 2.0.3 ~1.7-1.8s
- Java 9 (Classes) ~9s
- Java 9 (Optimized primitives) ~9s
- Node 8 ~9-10s
- Go 1.9.2 ~10-11s
- PHP 7.0 ~25s
- JRuby 9.1.15.0 ~25-29s
- Ruby 2.4.3 ~31-34s
- Python 3 ~320-450s (yes 5-8 minutes!)


Setup for running a test:
```
TYPE=ruby
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
```


Run this to spawn an ec2 instance that will test an individual countbits type:
```
# https://alestic.com/2013/11/aws-cli-query/
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
# https://stackoverflow.com/questions/10125311/how-to-fire-ec2-instances-and-upload-run-a-startup-script-on-each-of-them
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
echo $INSTANCEID


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
echo $DOMAIN
```


Some debugging and lookup tools you might want afterwards:
```
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html
ssh -i ~/.ssh/$KEYPAIR.pem ubuntu@$DOMAIN

tail -f /var/log/cloud-init-output.log


aws s3 ls --profile $PROFILE $BUCKET/$TYPE/
aws s3 cp --profile $PROFILE s3://$BUCKET/$TYPE/output_DATETIME.json ./

# https://stedolan.github.io/jq/tutorial/
sudo apt-get install jq
cat output_DATETIME.json | jq


aws ec2 describe-instances --profile $PROFILE --region $REGION --query 'Reservations[*].Instances[*].[LaunchTime, InstanceId, State.Name, Tags[0].Value]' --output text

aws ec2 terminate-instances --profile $PROFILE --region $REGION --instance-ids $INSTANCEID
```


Initial configuration to get all the right permissions, etc in place:
```
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
cat << EOF > ec2-role-trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
    --profile $PROFILE \
    --region $REGION \
    --role-name s3-put-role \
    --description "Write access to S3 $BUCKET" \
    --assume-role-policy-document file://ec2-role-trust-policy.json

# https://aws.amazon.com/blogs/security/a-safer-way-to-distribute-aws-credentials-to-ec2/
# http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_s3_deny-except-bucket.html
# http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_s3_rw-bucket-console.html
cat << EOF > s3-put-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::$BUCKET/*"
      ]
    }
  ]
}
EOF

aws iam put-role-policy \
    --profile $PROFILE \
    --region $REGION \
    --role-name s3-put-role \
    --policy-name s3-put-policy \
    --policy-document file://s3-put-policy.json

aws iam create-instance-profile --profile $PROFILE --region $REGION --instance-profile-name s3-put-profile

aws iam add-role-to-instance-profile --profile $PROFILE --region $REGION --instance-profile-name s3-put-profile --role-name s3-put-role


# http://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html
aws s3api list-buckets --profile $PROFILE --region $REGION
aws s3api create-bucket --profile $PROFILE --region $REGION --bucket $BUCKET --acl private

# http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-keypairs.html
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws
aws ec2 describe-key-pairs --profile $PROFILE
aws ec2 create-key-pair --profile $PROFILE --key-name $KEYPAIR --query 'KeyMaterial' --output text > ~/.ssh/$KEYPAIR.pem
chmod 400 ~/.ssh/$KEYPAIR.pem

# http://skillslane.com/aws-tutorial-vpc-launch-instance-cli/
# http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-subnets-commands-example.html
# https://console.aws.amazon.com/vpc/home?region=$REGION
VPCID=`aws ec2 describe-vpcs --profile $PROFILE --region $REGION --query 'Vpcs[*].VpcId' --output text`
echo $VPCID

# http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-sg.html
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html
# http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html#VPC_Security_Group_Differences
aws ec2 describe-security-groups --profile $PROFILE --region $REGION
SGID=$(aws ec2 create-security-group \
    --profile $PROFILE \
    --region $REGION \
    --vpc-id $VPCID \
    --group-name ssh-anywhere \
    --description "SSH from anywhere"
    --query 'GroupId'
    --output text)
aws ec2 authorize-security-group-ingress --profile $PROFILE --region $REGION --group-id $SGID --protocol tcp --port 22 --cidr 0.0.0.0/0
```

