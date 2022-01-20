#!/bin/bash

host="$1"
timeout="$2"
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"

paths=("" "/phpmyadmin" "/phpMyAdmin" "/mysql" "/sql" "/myadmin" "/pma")
unsec=("src=\"navigation.php" "src=\"main.php" "href=\"navigation.php\"")
sec=("input_username" "pma_username" "pma_password")


for p in "${paths[@]}"; do
	pmaurl=$(echo "http://${host}$p")
	echo "try: $pmaurl"
	html=$(curl -s --insecure -A "$useragent" -L --max-redirs 5 -m $timeout -D - "$pmaurl" )
	#~ echo "$html:$pmaurl" |grep -o "HTTP.*"
	for u in "${unsec[@]}"; do
		if [[ $html == *"$u"* ]];then
			echo "[FOUND] phpmyadmin: $pmaurl" |grep --color ".*"
			echo "$pmaurl" >> found_phpmyadmin.txt
			break
		fi
	done
	for u in "${sec[@]}"; do
		if [[ $html == *"$u"* ]];then
			echo "[FOUND] sec phpmyadmin: $pmaurl" |grep --color ".*"
			echo "$pmaurl" >> found_phpmyadmin_login.txt
			break
		fi
	done
done
