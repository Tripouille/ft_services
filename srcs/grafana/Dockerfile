FROM alpine

EXPOSE 3000
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add gcompat libc6-compat

RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-7.0.6.linux-amd64.tar.gz \
&& tar -zxf grafana-enterprise-7.0.6.linux-amd64.tar.gz && rm grafana-enterprise-7.0.6.linux-amd64.tar.gz

COPY defaults.ini /grafana-7.0.6/conf/
COPY start.sh /

ENTRYPOINT ["sh", "start.sh"]