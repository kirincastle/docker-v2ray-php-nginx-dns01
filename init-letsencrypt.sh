#!/bin/bash

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

domains=(yourdomain)
rsa_key_size=4096
data_path="${PWD}/data/letsencrypt"
email="dsf" # Adding a valid address is strongly recommended
staging=true # Set to true if you're testing your setup to avoid hitting request limits

if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

echo "### Deleting dummy certificate for $domains ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" dnsrobocert
echo

docker-compose up -d

echo

echo "## Checking if new Certficiate exists"

if [ -e "$data_path/live/$domains/fullchain.pem" ]; then
  echo "### New Certficiate is available, reloading nginx"
  docker-compose exec nginx nginx -s reload
  echo
fi

echo "#Generating v2ray link"
./data/v2ray/json2vmess.py -m port:443 -m tls:tls -a yourdomain -m ps:yourdomain --debug ./data/v2ray/config.json
