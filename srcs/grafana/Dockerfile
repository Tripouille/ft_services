FROM alpine

EXPOSE 3000
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add gcompat libc6-compat

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.5_linux_amd64.tar.gz \
&& tar xf telegraf-1.14.5_linux_amd64.tar.gz && rm telegraf-1.14.5_linux_amd64.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc
COPY telegraf.conf /etc/telegraf/

RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-7.0.6.linux-amd64.tar.gz \
&& tar -zxf grafana-enterprise-7.0.6.linux-amd64.tar.gz && rm grafana-enterprise-7.0.6.linux-amd64.tar.gz
COPY datasources.yml /grafana-7.0.6/conf/provisioning/datasources/
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]