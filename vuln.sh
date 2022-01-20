#!/bin/bash

#~ ===================================
#~ vuln.sh 1.1 - bop - mlc - ddr - bwc
#~ ===================================
#~ bash vuln1.1.sh ips.txt 1 9
#~ bash vuln1.1.sh 46.30.208.0/21 1 9
#~ bash vuln1.1.sh 5.101.152.0 5.101.152.255 1 9


main() {
    
    echo $1
    
    #~ config
    if [ $# == 3 ]; then
        threads=$2
        timeout=$3
    elif [ $# == 4 ]; then
        threads=$3
        timeout=$4
    fi
    
    #~ controlling
    if [ $# == 3 ] && [ -f "$1" ]; then
        echo "start scan with file"
        cat "$1" |cut -d"/" -f3 |cut -d":" -f1 |sort -n |uniq |xargs -P$threads -i bash ./lib/scan_worker.sh "{}" $timeout
    elif [ $# == 3 ] && [ ! -f "$2" ]; then
        echo "start scan with CIDR"
        ./bin/prips $1 |xargs -P$threads -i bash ./lib/scan_worker.sh "{}" $timeout
    elif [ $# == 4 ]; then 
        echo "start scan with range"
        ./bin/prips $1 $2 |xargs -P$threads -i bash ./lib/scan_worker.sh "{}" $timeout
    #~ USAGE
    else
        echo "USAGE: bash $0 <file> <threads> <timeout>"
        echo "USAGE: bash $0 <CIDR> <threads> <timeout>"
        echo "USAGE: bash $0 <startip> <endip> <threads> <timeout>"
        echo "USAGE: bash $0 ips.txt 1 9"
        echo "USAGE: bash $0 46.30.208.0/21 1 9"
        echo "USAGE: bash $0 5.101.152.0 5.101.152.255 1 9"
    fi
}


main $@
