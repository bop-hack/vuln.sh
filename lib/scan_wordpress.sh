#!/bin/bash

host="$1"
timeout="$2"
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"

paths=("" "/wordpress" "/wp" "/blog" "/Wordpress" "/Blog" "/cms" "/b" "/press" "/web" "/test" "/administrator" "/webblog" "/weblog")
marks=("wp-submit" "wp_attempt_focus()" "Powered by WordPress" "?action=lostpassword")
for p in "${paths[@]}"; do
	wpurl=$(echo "http://${host}${p}/wp-login.php")
	echo "try: $wpurl"
	wphtml=$(curl -s --insecure -A "$useragent" -L --max-redirs 5 -m $timeout -D - "$wpurl" )
	for m in "${marks[@]}"; do
		if [[ $wphtml == *"$m"* ]];then
			echo "[FOUND] Wordpress: $wpurl" |grep --color ".*"
			echo "$wpurl" >> found_wordpress.txt
			break 2
		fi
	done
done
