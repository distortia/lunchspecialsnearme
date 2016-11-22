#!/bin/bash

# Apps that need elevated priledges to install

echo "--------Installing ruby--------"
sudo apt-get install ruby-full -y

echo "--------Installing sass--------"
gem install sass

echo "--------Installing Postgres--------"
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib -y

echo "--------Adding postgres password and alphaity_dev database--------"
sudo -u postgres psql << EOF
\x
CREATE DATABASE alphaity_dev;
ALTER USER postgres WITH PASSWORD 'AYYLMAO'
EOF