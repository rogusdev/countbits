cd /root

# https://github.com/dotnet/core/issues/1037
export HOME=/root

# https://stackoverflow.com/questions/32407164/the-vm-is-running-with-native-name-encoding-of-latin1-which-may-cause-elixir-to
update-locale LC_ALL=en_US.UTF-8

apt-get update
apt-get install -yq git awscli

git clone https://github.com/rogusdev/countbits.git
