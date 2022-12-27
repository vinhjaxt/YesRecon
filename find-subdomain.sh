#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

export PATH="$PATH:${DIR}/bin"

amass enum -passive -d "$1"
subfinder -d "$1" -all -silent
findomain –quiet -t "$1"

dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o "${DIR}/puredns_resolvers.txt"
puredns bruteforce "${DIR}/puredns-all.txt" "$1" -w "puredns_$1_bf.txt" -r "${DIR}/puredns_resolvers.txt"
python3 "${DIR}/dnscan/dnscan.py" -d "$1" -w "${DIR}/dnscan/subdomains-10000.txt" -L "${DIR}/puredns_resolvers.txt"
python3 "${DIR}/dnscan/dnscan.py" -d "$1" -w "${DIR}/dnscan/subdomains.txt" -L "${DIR}/puredns_resolvers.txt"
shuffledns -d "$1" -w "${DIR}/shuffledns_subdomains.txt" -r "${DIR}/puredns_resolvers.txt"
shuffledns -d "$1" -w "${DIR}/shuffledns_best-dns-wordlist.txt" -r "${DIR}/puredns_resolvers.txt"

# gotator -sub org_known_subdomains.txt -perm permutations.txt -depth 1 -numbers 10 -mindup -adv -md -silent
# altdns -i org_known_subdomains.txt -w permutations.txt
# dmut --update-dnslist
# cat org_known_subdomains.txt | dmut -w 100 -d permutations.txt --dns-retries 3 -o dmut_results.txt -s ~/.dmut/resolvers.txt --dns-errorLimit 50 --dns-timeout 350
