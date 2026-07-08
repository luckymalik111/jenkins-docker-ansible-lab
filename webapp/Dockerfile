FROM nginx:alpine
RUN apk add --no-cache php83 php83-fpm php83-mysqli python3
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.php /var/www/html/index.php
COPY style.css /var/www/html/style.css
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
