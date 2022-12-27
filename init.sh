#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

sudo apt update -y && sudo apt install -y unzip curl python3 python3-pip

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
sudo cp "${DIR}/bin/massdns" /usr/bin/massdns
sudo chmod +x /usr/bin/massdns
curl -L -o "${DIR}/bin/puredns" https://github.com/vinhjaxt/puredns/releases/download/ActionBuild_2022.12.27_08-24-58/puredns
# wordlist
curl -L -o "${DIR}/puredns-all.txt" https://gist.githubusercontent.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
git clone --depth 1 --branch master https://github.com/vortexau/dnsvalidator
sudo sh -c 'cd dnsvalidator && python3 setup.py install'

# dnscan
git clone --depth 1 --branch master https://github.com/rbsec/dnscan "${DIR}/dnscan"
sh -c "cd '${DIR}/dnscan'; python3 -m pip install -r requirements.txt"

# shuffledns
curl -L -o "${DIR}/shuffledns_subdomains.txt" https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/subdomains/subdomains.txt
curl -L -o "${DIR}/shuffledns_2m-subdomains.txt" https://wordlists-cdn.assetnote.io/data/manual/2m-subdomains.txt
curl -L -o "${DIR}/shuffledns_best-dns-wordlist.txt" https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt
CURRENT_TMP="${TEMP_DIR}/shuffledns_linux_amd64"
curl -L -o "${CURRENT_TMP}.zip" https://github.com/projectdiscovery/shuffledns/releases/download/v1.0.8/shuffledns_1.0.8_linux_amd64.zip
unzip "${CURRENT_TMP}.zip" -d "${CURRENT_TMP}"
find "${CURRENT_TMP}/" -type f -name 'shuffledns' -exec mv {} "${DIR}/bin/" \;

# gotator
curl -L -o "${DIR}/bin/gotator" https://github.com/vinhjaxt/gotator/releases/download/ActionBuild_2022.12.27_08-31-18/gotator

# altdns
python3 -m pip install py-altdns==1.0.2

# dmut
curl -L -o "${DIR}/bin/dnsfaster" https://github.com/vinhjaxt/dnsfaster/releases/download/ActionBuild_2022.12.27_09-40-39/dnsfaster
chmod +x "${DIR}/bin/dnsfaster"
curl -L -o "${DIR}/dmut_public_nameserver.txt" https://public-dns.info/nameserver/us.txt
dnsfaster --domain google.com.vn --in "${DIR}/dmut_public_nameserver.txt" --out "${DIR}/dmut_nameserver.txt" --tests 1000 --workers 50 --filter-time 400 --filter-errors 50 --filter-rate 90 --save-dns
curl -L -o "${DIR}/bin/dmut" https://github.com/vinhjaxt/dmut/releases/download/ActionBuild_2022.12.27_08-39-56/dmut

chmod +x "${DIR}/bin/" -R
export PATH="$PATH:${DIR}/bin"

# test tools
httpx --help

amass --help
subfinder --help
findomain --help

puredns --help
dnsvalidator --help
massdns --help
python3 "${DIR}/dnscan/dnscan.py" --help
shuffledns -h

gotator --help
altdns --help
dmut --help
