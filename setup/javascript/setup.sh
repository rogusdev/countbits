curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

sudo apt-get update
sudo apt-get install -yq git nodejs

echo node $(node --version)
