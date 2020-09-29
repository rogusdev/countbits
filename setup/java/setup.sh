. countbits/setup/setup_asdf.sh

asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf install java $VERSION_JAVA
asdf global java $VERSION_JAVA

java -version
