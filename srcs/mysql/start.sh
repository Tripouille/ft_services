/usr/bin/mysql_install_db --user=mysql && /etc/init.d/mariadb setup 
rc-update add mariadb && openrc
while [ $(rc-service mariadb status | cut -d ' ' -f 4) != "started" ]; do
   sleep 1;
done
mysql < setup.sql && rm setup.sql
mysql wp < wp.sql && rm wp.sql
mysql phpmyadmin < phpmyadmin.sql && rm phpmyadmin.sql
cd /telegraf/usr/bin/ && ./telegraf
tail -f /dev/null