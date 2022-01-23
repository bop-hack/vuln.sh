#!/bin/bash

#~ add here your scan lib addon

main() {
	host=$1
	timeout=$2
	bash ./lib/scan_phpmyadmin.sh "$host" "$timeout"
	bash ./lib/scan_wordpress.sh "$host" "$timeout"
	bash ./lib/scan_ftp_anonymous.sh "$host" "$timeout"
	bash ./lib/scan_mysqldumper.sh "$host" "$timeout"
	bash ./lib/scan_mysql.sh "$host" "$timeout"
    echo "$host" > last.log
}


main $@
