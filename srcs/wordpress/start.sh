rc-update add lighttpd && openrc
cd /telegraf/usr/bin/ && ./telegraf &
tail -f /dev/null