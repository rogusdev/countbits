#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli python3

git clone https://github.com/rogusdev/countbits.git

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
python3 countbits/python/countbits.py > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/python/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/python/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

