#!/bin/bash
#Based on https://github.com/sergiotapia/magnetissimo/wiki/Usage:-Debian-7


curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

sudo apt-get update

sudo apt-get install -y -f
sudo apt-get install -y postgresql redis-server nodejs esl-erlang elixir git screen

cd /vagrant/
mix local.hex --force
mix local.rebar --force
yes | mix deps.get

echo " Setting up postgres "

psql postgres -c "CREATE USER torrent WITH PASSWORD 'password123';"
psql postgres -c "CREATE DATABASE torrent OWNER torrent ENCODING 'UTF8';"
psql postgres -c "ALTER USER torrent CREATEDB;"

# exit

#Change nano ./config/dev.exs

echo " DB Provision "
yes | mix ecto.create
yes | mix ecto.migrate

npm install