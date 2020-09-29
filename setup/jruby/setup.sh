. countbits/setup/java/setup.sh

curl https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.2.13.0/jruby-dist-9.2.13.0-bin.tar.gz | tar xvz
ln -s jruby-* jruby

export PATH=$(pwd)/jruby/bin:$PATH

jruby --version
