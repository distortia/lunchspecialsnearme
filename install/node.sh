#!/bin/bash

# Need to install node under the vagrant user so we can run the app

echo "--------Installing nvm--------"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 6.7

echo "--------Installing yarn--------"
npm install -g yarn

echo "--------Installing global node packages--------"
yarn global add knex
yarn global add parallelshell
yarn global add node-sass
yarn global add imagemin-cli
yarn global add uglifyjs

echo "--------Installing local node dependencies--------"
cd /vagrant/
echo "module.exports={development:{client:'postgresql',connection:{user:'postgres',password:'AYYLMAO',database:'alphaity_dev'}}}" > knexfile.js
yarn install