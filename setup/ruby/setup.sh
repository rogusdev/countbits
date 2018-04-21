sudo apt-get install -yq gcc

# https://github.com/rbenv/ruby-build/issues/156
curl https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz \
  | tar xvz && cd ruby-* && ./configure --disable-install-doc \
  && make && sudo make install && cd .. && rm -rf ruby-*
