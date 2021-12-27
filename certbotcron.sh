docker run --rm --name certbot \
-v "/root/docker-v2ray-php-nginx/data/certbot/conf:/etc/letsencrypt" \
-v "/root/docker-v2ray-php-nginx/data/certbot/www:/var/www/certbot" \
certbot/dns-cloudflare renew \
--dns-cloudflare \
--dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini \
--dns-cloudflare-propagation-seconds 20 \
-m xxx@hotmail.com --agree-tos --no-eff-email

docker exec nginx nginx -s reload

# 0 0 * * * bash /root/certbotcron.sh 2>&1 | ts | tee -a /root/certbot.log
