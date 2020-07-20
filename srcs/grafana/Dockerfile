FROM alpine

EXPOSE 3000
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add gcompat libc6-compat

#telegraf
COPY srcs/telegraf.tar.gz /
RUN tar xf telegraf.tar.gz && rm telegraf.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc/
COPY srcs/grafana/telegraf.conf /etc/telegraf/
#grafana
RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-7.0.6.linux-amd64.tar.gz \
&& tar -zxf grafana-enterprise-7.0.6.linux-amd64.tar.gz && rm grafana-enterprise-7.0.6.linux-amd64.tar.gz
COPY srcs/grafana/datasources.yml /grafana-7.0.6/conf/provisioning/datasources/
COPY srcs/grafana/dashboard.yml /grafana-7.0.6/conf/provisioning/dashboards/
COPY srcs/grafana/dashboards /dashboards

RUN echo "ps | grep grafana-server | grep -v grep && ps | grep telegraf | grep -v grep" > livenesscheck.sh
RUN echo "cd /grafana-7.0.6/bin/ && ./grafana-server &" > start.sh \
&& echo "cd /telegraf/usr/bin/ && ./telegraf" >> start.sh
ENTRYPOINT ["sh", "start.sh"]