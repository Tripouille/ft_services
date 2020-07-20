FROM alpine

EXPOSE 3306
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add mysql mysql-client gcompat libc6-compat

#telegraf
COPY srcs/telegraf.tar.gz /
RUN tar xf telegraf.tar.gz && rm telegraf.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc/
COPY srcs/mysql/telegraf.conf /etc/telegraf/
#mysql
COPY srcs/mysql/my.cnf /etc/
COPY srcs/mysql/setup.sql /
COPY srcs/mysql/wp.sql /
COPY srcs/mysql/phpmyadmin.sql /

RUN echo "! rc-status -c && ps | grep telegraf | grep -v grep" > livenesscheck.sh
COPY srcs/mysql/start.sh /
ENTRYPOINT ["sh", "start.sh"]