nginx -g "daemon off;" &
rc-update add sshd && openrc
cd /telegraf/usr/bin/ && ./telegraf
tail -f /dev/null