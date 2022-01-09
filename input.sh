read -p "Set to true if you're testing your setup, set to false if production: " staging
sed 's+staging_arg:.*+staging_arg: "'$staging'"+g' ./docker-compose.yml | sponge ./docker-compose.yml

read -p "your domain is: " yourdomain
sed 's+domain_args:.*+domain_args: '$yourdomain'+g' ./docker-compose.yml | sponge ./docker-compose.yml
sed 's+"Host": ".*"+"Host": "'"$yourdomain"'"+g' ./data/v2ray/config.json | sponge ./data/v2ray/config.json
sed 's+"Host": ".*"+"Host": "'"$yourdomain"'"+g' ./data/v2ray/config.json | sponge ./data/xray/config.json
sed "s/server_name .*;/server_name $yourdomain;/g" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed "s+https://.*$request_uri;+https://$yourdomain\$request_uri;+g" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed "s+/etc/letsencrypt/live/.*/+/etc/letsencrypt/live/$yourdomain/+g" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed "s+tls:tls -a .* -m ps:.*+tls:tls -a $yourdomain -m ps:$yourdomain --debug ./data/v2ray/config.json+g" ./init-letsencrypt.sh | sponge ./init-letsencrypt.sh
sed "s/domains=(.*)/domains=($yourdomain)/g" ./init-letsencrypt.sh | sponge ./init-letsencrypt.sh

read -p "your email for certificate registration is: " email
sed 's+email_arg:.*+email_arg: '$email'+g' ./docker-compose.yml | sponge ./docker-compose.yml
sed 's+email=".*"+email="'"$email"'"+g' ./init-letsencrypt.sh | sponge ./init-letsencrypt.sh

read -p "Authen token for cloudflare: " authtoken
sed 's+auth_token:.*+auth_token: '$authtoken'+g' ./docker-compose.yml | sponge ./docker-compose.yml

read -p "What is the v2ray web socket path? e.g. please input /abcpath (https://www.uuidgenerator.net/version1) : " path
sed 's+"path": ".*",+"path": "'"$path"'",+g' ./data/v2ray/config.json | sponge ./data/v2ray/config.json
sed 's+"path": ".*",+"path": "'"$path"'",+g' ./data/v2ray/config.json | sponge ./data/xray/config.json
sed "s+location .* {+location $path {+g" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf

read -p "What is the v2ray client ID UUID (https://www.uuidgenerator.net/version1): " id
sed 's+"id": ".*",+"id": "'"$id"'",+g' ./data/v2ray/config.json | sponge ./data/v2ray/config.json
sed 's+"id": ".*",+"id": "'"$id"'",+g' ./data/v2ray/config.json | sponge ./data/xray/config.json
