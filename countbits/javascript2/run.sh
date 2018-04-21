#!/bin/bash

cd /root

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

apt-get update
apt-get install -yq git awscli nodejs

git clone https://github.com/rogusdev/countbits.git

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
node countbits/js2/countbits.js > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/js2/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/js2/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

