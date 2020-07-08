FROM alpine

EXPOSE 5050
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add lighttpd php7-common php7-iconv php7-json php7-gd php7-curl php7-xml \
&& apk add php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap \
&& apk add php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-domls
COPY lighttpd.conf /etc/lighttpd/ 
RUN sed -i s/php-cgi/php-cgi7/ /etc/lighttpd/mod_fastcgi.conf
RUN wget https://fr.wordpress.org/latest-fr_FR.tar.gz -O wp.tar.gz \
&& tar -xf wp.tar.gz && rm wp.tar.gz
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]