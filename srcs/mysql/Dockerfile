FROM alpine

EXPOSE 3306
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add mysql mysql-client
COPY setup.sql /
COPY wp.sql /
COPY my.cnf /etc/
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]