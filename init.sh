#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

sudo apt install -y unzip curl python3 python3-pip

TEMP_DIR="$(mktemp -d)"

# httpx
CURRENT_TMP="${TEMP_DIR}/httpx_linux_amd64"
curl -L -o "${CURRENT_TMP}.zip" https://github.com/projectdiscovery/httpx/releases/download/v1.2.5/httpx_1.2.5_linux_amd64.zip
unzip "${CURRENT_TMP}.zip" -d "${CURRENT_TMP}"
find "${CURRENT_TMP}/" -type f -name 'httpx' -exec mv {} "${DIR}/bin/" \;

# amass
CURRENT_TMP="${TEMP_DIR}/amass_linux_amd64"
curl -L -o "${CURRENT_TMP}.zip" https://github.com/OWASP/Amass/releases/download/v3.21.2/amass_linux_amd64.zip
unzip "${CURRENT_TMP}.zip" -d "${CURRENT_TMP}"
find "${CURRENT_TMP}/" -type f -name 'amass' -exec mv {} "${DIR}/bin/" \;

# subfinder
CURRENT_TMP="${TEMP_DIR}/subfinder_linux_amd64"
curl -L -o "${CURRENT_TMP}.zip" https://github.com/projectdiscovery/subfinder/releases/download/v2.5.5/subfinder_2.5.5_linux_amd64.zip
unzip "${CURRENT_TMP}.zip" -d "${CURRENT_TMP}"
find "${CURRENT_TMP}/" -type f -name 'subfinder' -exec mv {} "${DIR}/bin/" \;

# findomain
CURRENT_TMP="${TEMP_DIR}/findomain-linux"
curl -L -o "${CURRENT_TMP}.zip" https://github.com/Findomain/Findomain/releases/download/8.2.1/findomain-linux.zip
unzip "${CURRENT_TMP}.zip" -d "${CURRENT_TMP}"
find "${CURRENT_TMP}/" -type f -name 'findomain' -exec mv {} "${DIR}/bin/" \;


# dnscan
git clone --depth 1 --branch master https://github.com/rbsec/dnscan "${DIR}/dnscan"
sh -c "cd '${DIR}/dnscan'; python3 -m pip install -r requirements.txt"

export PATH="$PATH:${DIR}/bin"

# test tools
httpx --help
amass --help
subfinder --help
findomain --help
python3 "${DIR}/dnscan/dnscan.py" --help
