# http://elixir-lang.github.io/install.html#unix-and-unix-like
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install -yq esl-erlang elixir
rm erlang-solutions_1.0_all.deb
