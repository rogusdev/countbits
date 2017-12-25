#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli gcc

git clone https://github.com/rogusdev/countbits.git

gcc -Wall countbits.cpp -o countbits
OUTFILE=output_`date +%Y%m%d%H%M%S`.json
countbits > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/cpp/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/cpp/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

