#!/bin/bash

PROCESS_REGEX=^httpd$
PROCESS_PATH=/root/homework/materials/class03/src/tinyhttpd/tinyhttpd/httpd
LOG_PATH=/root/httpd_start.log #/home/my/file.log
STR=`pgrep $PROCESS_REGEX`
# echo $STR	
if [ -z $STR ]
then
	#echo "Process corresponding to REGEX $PROCESS_REGEX is not running"
	$PROCESS_PATH &> /dev/null &
	{ 
		DATE=`date +"%T %m-%d-%y"`
		echo -n ${DATE//\n/}
		echo " httpd was not running, starting..." 
	} >> "$LOG_PATH";
fi
