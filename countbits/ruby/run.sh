#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli build-essential gcc

git clone https://github.com/rogusdev/countbits.git

# https://github.com/rbenv/ruby-build/issues/156
curl https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.3.tar.gz \
  | tar xvz && cd ruby-* && ./configure --disable-install-doc && make && make install && cd .. && rm -rf ruby-*

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
ruby countbits/ruby/countbits.rb > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/ruby/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/ruby/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

