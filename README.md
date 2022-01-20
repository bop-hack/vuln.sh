# bop fxp scan toolz

scan toolz for fxp scene

## vuln.sh
to scan pma, wordpress, ftp, sql etc..
```
bash vuln.sh <ipfile> <threads> <timeout>
bash vuln.sh <CIDR> <threads> <timeout>
bash vuln.sh <startip> <endip> <threads> <timeout>

bash vuln.sh ips.txt 1 9
bash vuln.sh 46.30.208.0/21 1 9
bash vuln.sh 5.101.152.0 5.101.152.255 1 9
```

# HAVE FUN!



# vuln.sh Changelog
## v1.2
- mysql works now
## v1.1
- libs
- last code: mysql
 - leider breaked er nicht bei no mysql
## v1.0
- start project
