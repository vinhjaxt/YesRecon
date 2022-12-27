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

# puredns
# https://github.com/vinhjaxt/massdns/releases/download/ActionBuild_2022.12.27_08-49-45/massdns
git clone --depth 1 https://github.com/blechschmidt/massdns.git
sh -c 'cd massdns && make'
mv "${DIR}/massdns/bin/massdns" "${DIR}/bin/massdns"
curl -L -o "${DIR}/bin/puredns" https://github.com/vinhjaxt/puredns/releases/download/ActionBuild_2022.12.27_08-24-58/puredns

# dnscan
git clone --depth 1 --branch master https://github.com/rbsec/dnscan "${DIR}/dnscan"
sh -c "cd '${DIR}/dnscan'; python3 -m pip install -r requirements.txt"

# shuffledns
CURRENT_TMP="${TEMP_DIR}/shuffledns_linux_amd64"
curl -L -o "${CURRENT_TMP}.zip" https://github.com/projectdiscovery/shuffledns/releases/download/v1.0.8/shuffledns_1.0.8_linux_amd64.zip
unzip "${CURRENT_TMP}.zip" -d "${CURRENT_TMP}"
find "${CURRENT_TMP}/" -type f -name 'shuffledns' -exec mv {} "${DIR}/bin/" \;

# gotator
curl -L -o "${DIR}/bin/gotator" https://github.com/vinhjaxt/gotator/releases/download/ActionBuild_2022.12.27_08-31-18/gotator

# altdns
python3 -m pip install py-altdns==1.0.2

# dmut
curl -L -o "${DIR}/bin/dmut" https://github.com/vinhjaxt/dmut/releases/download/ActionBuild_2022.12.27_08-39-56/dmut

chmod +x "${DIR}/bin/" -R
export PATH="$PATH:${DIR}/bin"

# test tools
httpx --help || exit 1

amass --help || exit 1
subfinder --help || exit 1
findomain --help || exit 1

puredns --help || exit 1
massdns --help || exit 1
python3 "${DIR}/dnscan/dnscan.py" --help || exit 1
shuffledns -h || exit 1

gotator --help || exit 1
altdns --help || exit 1
dmut --help || exit 1
