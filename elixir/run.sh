#!/bin/bash

cd /root

# http://elixir-lang.github.io/install.html#unix-and-unix-like
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -yq git awscli esl-erlang elixir

git clone https://github.com/rogusdev/countbits.git

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
elixir countbits.ex > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/elixir/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
#shutdown -h now

