#!/bin/bash

cd /home/ubuntu/app
sudo npm install
sudo chown -R 1000:1000 "/home/ubuntu/.npm"
npm start
