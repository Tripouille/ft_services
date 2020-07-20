FROM alpine

EXPOSE 21 1024
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add vsftpd --no-cache \
&& apk add openssl gcompat libc6-compat

#telegraf
COPY srcs/telegraf.tar.gz /
RUN tar xf telegraf.tar.gz && rm telegraf.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc/
COPY srcs/ftps/telegraf.conf /etc/telegraf/
#ftps
RUN echo -e "admin\nadmin" | adduser admin
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
-subj "/C=FT/ST=SERVICE/L=C/O=LA/CN=www.MORT.com" \
-keyout /etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem
COPY srcs/ftps/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir -p /var/log/ftp

RUN echo "! rc-status -c && ps | grep telegraf | grep -v grep" > livenesscheck.sh
RUN echo "rc-update add vsftpd && openrc" > start.sh \
&& echo "cd /telegraf/usr/bin/ && ./telegraf" >> start.sh
ENTRYPOINT ["sh", "start.sh"]