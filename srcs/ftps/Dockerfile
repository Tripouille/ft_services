FROM alpine

EXPOSE 21 1024
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add vsftpd --no-cache \
&& apk add openssl gcompat libc6-compat

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_linux_amd64.tar.gz \
&& tar xf telegraf-1.14.5_linux_amd64.tar.gz && rm telegraf-1.14.5_linux_amd64.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc
COPY telegraf.conf /etc/telegraf/

RUN echo -e "admin\nadmin" | adduser admin
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
-subj "/C=FT/ST=SERVICE/L=C/O=LA/CN=www.MORT.com" \
-keyout /etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir -p /var/log/ftp
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]