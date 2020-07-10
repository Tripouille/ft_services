FROM alpine

EXPOSE 3306
USER root
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add mysql mysql-client
RUN /usr/bin/mysql_install_db --user=mysql && /etc/init.d/mariadb setup 
COPY pma.sql /
COPY setup.sql /
COPY my.cnf /etc/

COPY start.sh /
ENTRYPOINT ["sh", "start.sh"]