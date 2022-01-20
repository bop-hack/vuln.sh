#!/bin/bash

host="$1"
timeout="$2"


ip=$(echo "$host" |cut -d":" -f1)

echo "try: ftp://$host/"
if curl -s --list-only "ftp://$ip/" -m ${timeout} ; then
	echo "[ftp] anonymous login works: $ip:21" |grep --color ".*"
	echo "$ip:21" >> found_ftp_anonymous.txt
fi

