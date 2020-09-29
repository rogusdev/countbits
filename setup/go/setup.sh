# https://golang.org/doc/install#download
sudo rm -rf /usr/local/go
wget -L https://golang.org/dl/go1.15.2.linux-amd64.tar.gz \
  && sudo tar -C /usr/local -xzf go*.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile
export PATH=$PATH:/usr/local/go/bin

go version
