# https://golang.org/doc/install && https://golang.org/dl/
sudo rm -rf /usr/local/go
wget -L https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz \
  && sudo tar -C /usr/local -xzf go*.tar.gz

export PATH=/usr/local/go/bin:$PATH
