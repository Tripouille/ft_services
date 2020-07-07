FROM alpine

EXPOSE 21 1024
RUN apk -U upgrade --no-cache \
 && apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
 && apk add vsftpd --no-cache \
 && apk add openssl --no-cache
RUN echo -e "admin\nadmin" | adduser admin
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
-subj "/C=FT/ST=SERVICE/L=C/O=LA/CN=www.MORT.com" \
-keyout /etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir -p /var/log/ftp
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]