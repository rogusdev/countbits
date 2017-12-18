#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli

git clone https://github.com/rogusdev/countbits.git

curl https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz \
  | tar -C /usr/local -xzf go*.tar.gz

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
cd countbits/go
go build
countbits > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/go/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

