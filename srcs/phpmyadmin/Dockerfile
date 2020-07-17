FROM alpine

EXPOSE 5000
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add lighttpd php7-common php7-iconv php7-json php7-gd php7-curl php7-xml \
&& apk add php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap \
&& apk add php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype \
&& apk add phpmyadmin php-mbstring php-gettext gcompat libc6-compat

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_linux_amd64.tar.gz \
&& tar xf telegraf-1.14.5_linux_amd64.tar.gz && rm telegraf-1.14.5_linux_amd64.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc
COPY telegraf.conf /etc/telegraf/

COPY lighttpd.conf /etc/lighttpd/ 
RUN sed -i s/php-cgi/php-cgi7/ /etc/lighttpd/mod_fastcgi.conf
COPY config.inc.php /usr/share/webapps/phpmyadmin
COPY config.inc.php /etc/phpmyadmin/
RUN chmod -R 755 /usr/share/webapps/phpmyadmin
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]