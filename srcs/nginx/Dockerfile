FROM alpine

RUN apk -U upgrade --no-cache
RUN mkdir -p /var/www/html/ && echo "Bienvenue sur notre ft_services !" > /var/www/html/index.html
RUN mkdir -p /run/nginx && apk add nginx
COPY localhost.crt /etc/ssl/certs/
COPY localhost.key /etc/ssl/private/
COPY default /etc/nginx/conf.d/default.conf
EXPOSE 22 80 443

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]