FROM alpine

EXPOSE 22 80 443
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add openssh --no-cache \
&& apk add openssl gcompat libc6-compat

#telegraf
COPY srcs/telegraf.tar.gz /
RUN tar xf telegraf.tar.gz && rm telegraf.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc/
COPY srcs/nginx/telegraf.conf /etc/telegraf/
#nginx
RUN echo -e "admin\nadmin" | adduser admin
RUN mkdir -p /var/www/html/ && echo "ft_services" > /var/www/html/index.html
RUN mkdir -p /run/nginx && apk add nginx
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
-subj "/C=FT/ST=SERVICE/L=C/O=LA/CN=www.MORT.com" \
-keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt
COPY srcs/nginx/default /etc/nginx/conf.d/default.conf

RUN echo "! rc-status -c && ps | grep nginx | grep -v grep && ps | grep telegraf | grep -v grep" > livenesscheck.sh
RUN echo "rc-update add sshd && openrc" > start.sh \
&& echo 'nginx -g "daemon off;" &'  >> start.sh \
&& echo "cd /telegraf/usr/bin/ && ./telegraf"  >> start.sh
ENTRYPOINT ["sh", "start.sh"]