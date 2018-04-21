# oracle java, probably best via some user PPA:
#  http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html
# https://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option/637514#637514
# must switch to java 11 soon! http://www.oracle.com/technetwork/java/eol-135779.html
sudo add-apt-repository -y ppa:webupd8team/java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

sudo apt-get update
sudo apt-get install -yq oracle-java8-installer

export JAVA_HOME=/usr/lib/jvm/java-8-oracle
