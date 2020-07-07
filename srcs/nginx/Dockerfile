FROM alpine

EXPOSE 22 80 443
RUN apk -U upgrade --no-cache \
 && apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
 && apk add openssh --no-cache \
 && apk add openssl --no-cache
RUN echo -e "admin\nadmin" | adduser admin
RUN mkdir -p /var/www/html/ && echo "Bienvenue sur notre ft_services !" > /var/www/html/index.html
RUN mkdir -p /run/nginx && apk add nginx
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
-subj "/C=FT/ST=SERVICE/L=C/O=LA/CN=www.MORT.com" \
-keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt
COPY default /etc/nginx/conf.d/default.conf
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]