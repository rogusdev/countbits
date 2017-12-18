#!/bin/bash

cd /root

# oracle java, probably best via some user PPA:
#  http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html
# https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option/637514#637514
sudo add-apt-repository -y ppa:webupd8team/java
echo oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

sudo apt-get update
sudo apt-get install -yq git awscli oracle-java9-installer

export JAVA_HOME=/usr/lib/jvm/java-9-oracle

# https://github.com/rbenv/ruby-build/issues/156
curl https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.1.15.0/jruby-dist-9.1.15.0-bin.tar.gz | tar xvz
ln -s jruby-* jruby

export PATH=$(pwd)/jruby/bin:$PATH

git clone https://github.com/rogusdev/countbits.git

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
jruby countbits/rb/countbits.rb > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/jruby/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

