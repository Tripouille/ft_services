FROM alpine

EXPOSE 22 80 443
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add openssh --no-cache \
&& apk add openssl gcompat libc6-compat

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_linux_amd64.tar.gz \
&& tar xf telegraf-1.14.5_linux_amd64.tar.gz && rm telegraf-1.14.5_linux_amd64.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc
COPY telegraf.conf /etc/telegraf/

RUN echo -e "admin\nadmin" | adduser admin
RUN mkdir -p /var/www/html/ && echo "ft_services" > /var/www/html/index.html
RUN mkdir -p /run/nginx && apk add nginx
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
-subj "/C=FT/ST=SERVICE/L=C/O=LA/CN=www.MORT.com" \
-keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt
COPY default /etc/nginx/conf.d/default.conf
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]