#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli

git clone https://github.com/rogusdev/countbits.git

# https://github.com/rust-lang-nursery/rustup.rs/#other-installation-methods
curl https://sh.rustup.rs -sSf | sh -s -- -y

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
rustc countbits.rs
./countbits > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/rust/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/rust/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

