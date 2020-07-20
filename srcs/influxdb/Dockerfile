FROM alpine

EXPOSE 8086
RUN apk -U upgrade --no-cache \
&& apk add openrc --no-cache && mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
&& apk add influxdb gcompat libc6-compat

#telegraf
COPY srcs/telegraf.tar.gz /
RUN tar xf telegraf.tar.gz && rm telegraf.tar.gz \
&& cp -R /telegraf/etc/telegraf /etc/ && mkdir -p /etc/influxdb
COPY srcs/influxdb/telegraf.conf /etc/telegraf/
#influxdb
COPY srcs/influxdb/influxdb.conf /etc/influxdb/

RUN echo "ps | grep influxd | grep -v grep && ps | grep telegraf | grep -v grep" > livenesscheck.sh
RUN echo "influxd -config /etc/influxdb/influxdb.conf &" > start.sh \
&& echo "cd /telegraf/usr/bin/ && ./telegraf" >> start.sh
ENTRYPOINT ["sh", "start.sh"]