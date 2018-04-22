cd /root

# https://github.com/dotnet/core/issues/1037
export HOME=/root

apt-get update
apt-get install -yq git awscli

git clone https://github.com/rogusdev/countbits.git
