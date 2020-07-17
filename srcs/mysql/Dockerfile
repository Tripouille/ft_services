FROM alpine

EXPOSE 3306
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add mysql mysql-client gcompat libc6-compat

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_linux_amd64.tar.gz \
&& tar xf telegraf-1.14.5_linux_amd64.tar.gz && rm telegraf-1.14.5_linux_amd64.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc
COPY telegraf.conf /etc/telegraf/

COPY setup.sql /
COPY wp.sql /
COPY phpmyadmin.sql /
COPY my.cnf /etc/
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]