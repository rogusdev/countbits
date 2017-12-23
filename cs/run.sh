#!/bin/bash

cd /root

# dotnet new console CountBits
# dotnet add package Newtonsoft.Json


curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list' 

apt-get update
apt-get install -yq git awscli dotnet-sdk-2.0.3

git clone https://github.com/rogusdev/countbits.git

# https://github.com/dotnet/core/issues/1037
export HOME=/root

# https://www.michaelcrump.net/part12-aspnetcore/
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# https://github.com/dotnet/cli/issues/6815
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

OUTFILE=output_`date +%Y%m%d%H%M%S`.json
dotnet run -p countbits/cs/CountBits.csproj > $OUTFILE

aws s3 cp $OUTFILE s3://rogusdev-countbits/cs/
#aws s3 cp /var/log/cloud-init-output.log s3://rogusdev-countbits/cs/

# https://stackoverflow.com/questions/10541363/self-terminating-aws-ec2-instance
# https://askubuntu.com/questions/578144/why-doesnt-running-sudo-shutdown-now-shut-down/578155
shutdown -h now

