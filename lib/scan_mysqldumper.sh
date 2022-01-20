#!/bin/bash

host="$1"
timeout="$2"


paths=("/" "/msd" "/mySqlDumper" "/msd1.24stable" "/msd1.24.4" "/mysqldumper" "/MySQLDumper" "/mysql" "/sql" "mysql-dumper")
mark="<title>MySQLDumper</title>"
for i in "${paths[@]}"; do
	echo "try: http://$host$i"
	myurl=$(echo "http://$host$i")
	#~ echo "curl -A \"$useragent\" -L --max-redirs 5 -m $timeout -D \"$myurl\""
	myhtml=$(curl -s --insecure -A "$useragent" -L --max-redirs 5 -m $timeout -D - "$myurl" )
	#~ echo "$myhtml" |grep -o "HTTP.*"
	if [[ "$mythml" == *"$mark"* ]];then
		echo "[FOUND] mysqldumper: $myurl" |grep --color ".*"
		echo "$myurl" >> found_mysqldumper.txt
	fi
done
