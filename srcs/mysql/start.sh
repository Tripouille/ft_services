rc-update add mariadb && openrc
while [ $(rc-service mariadb status | cut -d ' ' -f 4) != "started" ]; do
   sleep 1;
done
mysql -u root -p=password < setup.sql && rm setup.sql
mysql -u root -p=password phpmyadmin < pma.sql && rm pma.sql
tail -f /dev/null