#!/bin/bash

iptables -A INPUT -s 177.67.90.211 -j DROP

echo "added iptable blacklist " > /tmp/result.txt

if [ -f /usr/local/tomcat/logs/localhost_access_log.2018-04-09.txt ]; then
     mv /usr/local/tomcat/logs/localhost_access_log.2018-04-09.txt test.txt
fi

CONSOLERESULT="$grep 'ConsoleResult' /usr/local/tomcat/logs/localhost_access_*"

if [ ! -z "$CONSOLERESULT" ]; then
    echo -e "console result in locahost logs" >> /tmp/result.txt
fi

if [ -f /tmp/config.json ]; then
    echo -e "found config.json" >> /tmp/result.txt	
    rm -rf /tmp/config.json
fi
if [ -f /tmp/bashd ]; then
    rm -rf /tmp/bashd
    echo -e "found bashd" >> /tmp/result.txt
fi
if [ -f /tmp/r88.sh ]; then
    rm -rf /tmp/r88.sh
    echo -e "found r88" >> /tmp/result.txt
fi
if [ -f /tmp/lowerv2.sh ]; then
    rm -rf /tmp/lowerv2.sh
    echo -e "found lowerv2" >> /tmp/result.txt
fi
if [ -f /tmp/root.sh ]; then
    rm -rf /tmp/root.sh
    echo -e "found root" >> /tmp/result.txt
fi
if [ -f /tmp/rootv2.sh ]; then
    rm -rf /tmp/rootv2.sh
    echo -e "found rootv2" >> /tmp/result.txt
fi


p=$(ps aux | grep bashd | grep -v grep | wc -l)
	if [ ${p} -eq 1 ];then
	  ps -ef | grep bashd | grep -v grep | awk '{print $2}' | xargs kill
	else
	  echo "bashd not running" >> /tmp/result.txt
	fi

s=$(ps aux | grep 'sleep 3600' | grep -v grep | wc -l)
        if [ ${s} -eq 1 ];then
          ps -ef | grep 'sleep 3600' | grep -v grep | awk '{print $2}' | xargs kill
        else
          echo "killed sleeping script" >> /tmp/result.txt
        fi

cd /usr/local/Optergy/bin
exec java com.optergy.lib.licence.HardwareKey >> /tmp/result.txt &


rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/com/optergy/web/action/tools/Console.class
rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/com/optergy/web/action/tools/ajax/Console*

sudo service tomcat restart

cat /tmp/result.txt
