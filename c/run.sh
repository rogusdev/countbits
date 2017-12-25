#!/bin/bash

cd /root

apt-get update
apt-get install -yq git awscli build-essential gcc autoconf automake libtool

# https://github.com/json-c/json-c
# https://linuxprograms.wordpress.com/2010/05/20/json-c-libjson-tutorial/
git clone https://github.com/json-c/json-c.git
cd json-c && sh autogen.sh && ./configure && make && make install && cd ..

git clone https://github.com/rogusdev/countbits.git

cd countbits/c

# https://gist.github.com/alan-mushi/19546a0e2c6bd4e059fd
gcc -Wall -g -I/usr/local/include/json-c/ countbits.c -o countbits -ljson-c
# https://stackoverflow.com/questions/480764/linux-error-while-loading-shared-libraries-cannot-open-shared-object-file-no-s
export LD_LIBRARY_PATH=/usr/local/lib
OUTFILE=output_`date +%Y%m%d%H%M%S`.json
./countbits > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/c/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/c/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

