nginx -g "daemon off;" &
rc-update add sshd && openrc
tail -f /dev/null