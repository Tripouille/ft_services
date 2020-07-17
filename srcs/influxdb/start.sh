influxd -config /etc/influxdb.conf &
cd /telegraf/usr/bin/ && ./telegraf
tail -f /dev/null