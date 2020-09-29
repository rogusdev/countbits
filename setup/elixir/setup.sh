# http://elixir-lang.github.io/install.html#unix-and-unix-like
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install -y esl-erlang elixir
rm erlang-solutions_2.0_all.deb

# https://github.com/voxpupuli/puppet-rabbitmq/issues/671
# https://github.com/elixir-lang/elixir/issues/3548
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

erl -version
