. ../java/setup.sh

curl https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.1.16.0/jruby-dist-9.1.16.0-bin.tar.gz | tar xvz
ln -s jruby-* jruby

export PATH=$(pwd)/jruby/bin:$PATH
