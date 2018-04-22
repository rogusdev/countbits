sudo apt-get install -yq build-essential gcc

# https://github.com/rust-lang-nursery/rustup.rs/#other-installation-methods
# https://www.rust-lang.org/en-US/install.html
curl https://sh.rustup.rs -sSf | sh -s -- -y

echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> $HOME/.profile
PATH="$HOME/.cargo/bin:$PATH"
