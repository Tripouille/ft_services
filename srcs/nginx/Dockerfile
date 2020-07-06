FROM alpine

EXPOSE 22 80 443
RUN apk -U upgrade --no-cache \
 && apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
 && apk add openssh --no-cache
RUN echo -e "admin\nadmin" | adduser admin
RUN mkdir -p /var/www/html/ && echo "Bienvenue sur notre ft_services !" > /var/www/html/index.html
RUN mkdir -p /run/nginx && apk add nginx
COPY localhost.crt /etc/ssl/certs/
COPY localhost.key /etc/ssl/private/
COPY default /etc/nginx/conf.d/default.conf
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]