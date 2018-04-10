#!/bin/bash

iptables -A INPUT -s 177.67.90.211 -j DROP

echo "blocked malware ip " > /tmp/result.txt

if [ -f /usr/local/tomcat/logs/localhost_access_log.2018-04-10.txt ]; then
     mv /usr/local/tomcat/logs/localhost_access_log.2018-04-10.txt test.txt
fi

CONSOLERESULT=$(grep 'ConsoleResult' /usr/local/tomcat/logs/localhost_access_*)

if [ ! -z "$CONSOLERESULT" ]; then
    echo -e "ConsoleResult FOUND in locahost logs. Number of hits found are: \c" >> /tmp/result.txt
    echo -n "$CONSOLERESULT" | grep -c '^' >> /tmp/result.txt
fi

if [ -f /tmp/config.json ]; then
    echo -e "found config.json; deleted" >> /tmp/result.txt	
    rm -rf /tmp/config.json
fi
if [ -f /tmp/bashd ]; then
    rm -rf /tmp/bashd
    echo -e "found bashd malware executable; deleted" >> /tmp/result.txt
fi
if [ -f /tmp/r88.sh ]; then
    rm -rf /tmp/r88.sh
    echo -e "found r88; deleted" >> /tmp/result.txt
fi
if [ -f /tmp/lowerv2.sh ]; then
    rm -rf /tmp/lowerv2.sh
    echo -e "found lowerv2; deleted" >> /tmp/result.txt
fi
if [ -f /tmp/root.sh ]; then
    rm -rf /tmp/root.sh
    echo -e "found root.sh; deleted" >> /tmp/result.txt
fi
if [ -f /tmp/rootv2.sh ]; then
    rm -rf /tmp/rootv2.sh
    echo -e "found rootv2; deleted" >> /tmp/result.txt
fi


p=$(ps aux | grep bashd | grep -v grep | wc -l)
	if [ ${p} -eq 1 ];then
	  ps -ef | grep bashd | grep -v grep | awk '{print $2}' | xargs kill
      echo "malware process killed..." >> /tmp/result.txt
	else
	  echo "malware process not found " >> /tmp/result.txt
	fi

s=$(ps aux | grep 'sleep 3600' | grep -v grep | wc -l)
        if [ ${s} -eq 1 ];then
          ps -ef | grep 'sleep 3600' | grep -v grep | awk '{print $2}' | xargs kill
          echo "sleeping script killed..." >> /tmp/result.txt
        fi

cd /usr/local/Optergy/bin
exec java com.optergy.lib.licence.HardwareKey >> /tmp/result.txt &
wait

echo "removing backdoor"

rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/com/optergy/web/action/tools/Console.class
rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/com/optergy/web/action/tools/ajax/Console*

cat /tmp/result.txt ; sudo invoke-rc.d tomcat restart &
wait