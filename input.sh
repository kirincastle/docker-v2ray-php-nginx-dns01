read -p "Set to true if you're testing your setup, set to false if production: " staging
sed 's+staging_arg:.*+staging_arg: "'$staging'"+g' ./docker-compose.yml | sponge ./docker-compose.yml

read -p "your domain is: " yourdomain
sed 's+domain_args:.*+domain_args: '$yourdomain'+g' ./docker-compose.yml | sponge ./docker-compose.yml
sed 's+"Host": ".*"+"Host": "'"$yourdomain"'"+g' ./data/v2ray/config.json | sponge ./data/v2ray/config.json
sed 's+"Host": ".*"+"Host": "'"$yourdomain"'"+g' ./data/xray/config.json | sponge ./data/xray/config.json
sed  "s+"$(awk '/server_name/{i++;if (i==1){print $2}}' ./data/nginx/conf.d/v2ray.conf)"+$yourdomain+" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed "s+https://.*:443\$request_uri;+https://$yourdomain:443\$request_uri;+g" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed -r 's/sub_filter '"(.*?)"' '"(.*?)"';/sub_filter \1 "'$yourdomain'";/g' ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed "s+/etc/letsencrypt/live/.*/+/etc/letsencrypt/live/$yourdomain/+g" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed "s+tls:tls -a .* -m ps:.*+tls:tls -a $yourdomain -m ps:$yourdomain --debug ./data/v2ray/config.json+g" ./init-letsencrypt.sh | sponge ./init-letsencrypt.sh
sed "s/domains=(.*)/domains=($yourdomain)/g" ./init-letsencrypt.sh | sponge ./init-letsencrypt.sh

read -p "please input website that will be proxied: e.g www.github.com: " fakeweb
sed -r 's/proxy_pass https:\/\/(.*?)\/;/proxy_pass https:\/\/'$fakeweb'\/;/g' ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed  "s+"$(awk '/sub_filter/{i++;if (i==1){print $2}}' ./data/nginx/conf.d/v2ray.conf)"+\"$fakeweb\"+" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf

read -p "your email for certificate registration is: " email
sed 's+email_arg:.*+email_arg: '$email'+g' ./docker-compose.yml | sponge ./docker-compose.yml
sed 's+email=".*"+email="'"$email"'"+g' ./init-letsencrypt.sh | sponge ./init-letsencrypt.sh

read -p "Authen token for cloudflare: " authtoken
sed 's+auth_token:.*+auth_token: '$authtoken'+g' ./docker-compose.yml | sponge ./docker-compose.yml

read -p "What is the v2ray web socket path? e.g. please input /path ( https://www.uuidtools.com/v1 ) : " path
sed 's+"path": ".*",+"path": "'"$path"'",+g' ./data/v2ray/config.json | sponge ./data/v2ray/config.json
sed  "s+"$(awk '/location/{i++;if (i==5){print $2}}' ./data/nginx/conf.d/v2ray.conf)"+$path+" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf

read -p "What is the v2ray and xray client ID UUID ( https://www.uuidtools.com/v1 ): " id
sed 's+"id": ".*",+"id": "'"$id"'",+g' ./data/v2ray/config.json | sponge ./data/v2ray/config.json
sed 's+"id": ".*",+"id": "'"$id"'",+g' ./data/xray/config.json | sponge ./data/xray/config.json

read -p "Please input a different web socket path for xray? e.g. please input /path ( https://www.uuidtools.com/v1 ) : " xpath
sed  "s+"$(awk '/location/{i++;if (i==4){print $2}}' ./data/nginx/conf.d/v2ray.conf)"+$xpath+" ./data/nginx/conf.d/v2ray.conf | sponge ./data/nginx/conf.d/v2ray.conf
sed 's+"path": ".*",+"path": "'"$xpath"'",+g' ./data/xray/config.json | sponge ./data/xray/config.json
