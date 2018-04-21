#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli php7.0-cli

git clone https://github.com/rogusdev/countbits.git

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
php countbits/php/countbits.php > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/php/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/php/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

