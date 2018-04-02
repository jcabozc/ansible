#/usr/bin/python
#This script is used to discovery disk on the server
import subprocess
import json
args="ip link |grep 'state UP mode' | awk -F':| *' '{print $3}' | grep -v bond"
t=subprocess.Popen(args,shell=True,stdout=subprocess.PIPE).communicate()[0]
 
nics=[]
 
for nic in t.split('\n'):
    if len(nic) != 0:
       nics.append({'{#IFNAME}':nic})
print json.dumps({'data':nics},indent=4,separators=(',',':'))
