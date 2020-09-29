#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -yq git curl build-essential libssl-dev libreadline-dev  # linux-headers-$(uname -r)
sudo apt-get install -yq jq unzip libcurl4 libcurl4-openssl-dev zlib1g-dev libpng-dev
sudo apt-get autoremove -y


HOME_ASDF='$HOME/.asdf'
ASDF_DIR=$(eval echo "$HOME_ASDF")
git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch v0.7.8

# https://unix.stackexchange.com/a/419059/83622
ASDF_BASH_SOURCE="source $HOME_ASDF/asdf.sh && source $HOME_ASDF/completions/asdf.bash"
#echo -e "\n$ASDF_BASH_SOURCE" >> $PROFILE_FILE
$(eval echo "$ASDF_BASH_SOURCE")

asdf update


# https://asdf-vm.com/#/core-configuration?id=homeasdfrc
cat << EOF > $HOME/.asdfrc
legacy_version_file = yes
EOF


VERSION_RUST=1.46.0
VERSION_DOTNET_CORE=3.1.402
VERSION_GOLANG=1.15.2
# https://adoptopenjdk.net/ vs https://aws.amazon.com/corretto/ vs https://www.azul.com/downloads/zulu/
# hotspot vs openj9: https://www.ojalgo.org/2019/02/quick-test-to-compare-hotspot-and-openj9/
VERSION_JAVA=adoptopenjdk-11.0.8+10
VERSION_NODEJS=14.11.0
VERSION_RUBY=2.7.1
VERSION_PYTHON=3.8.5
VERSION_ERLANG=22.3
VERSION_ELIXIR=1.10
