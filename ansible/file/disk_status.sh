#/bin/sh
 
device=$1
item=$2

flock -xn /usr/local/zabbix/logs/iostat.pid -c "nohup iostat -dxkt 10 8640 > /tmp/iostat_output 2>&1 &"
 
case $item in
         rrqm)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b"|tail -1|awk '{print $2}'
            ;;
         wrqm)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b"|tail -1|awk '{print $3}'
            ;;
          rps)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b"|tail -1|awk '{print $4}'
            ;;
          wps)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $5}'
            ;;
        rKBps)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $6}'
            ;;
        wKBps)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $7}'
            ;;
     avgrq-sz)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $8}'
            ;;
     avgqu-sz)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $9}'
            ;;
        await)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $10}'
            ;;
      r_await)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $11}'
            ;;
      w_await)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $12}'
            ;;
        svctm)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $13}'
            ;;
         util)
            /usr/bin/tail -n40 /tmp/iostat_output |grep "\b$device\b" |tail -1|awk '{print $14}'
            ;;

esac
