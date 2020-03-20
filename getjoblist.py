from __future__ import print_function
import base64
import string
import httplib
import json
import os
import sys

JENKINS_IP=sys.argv[1]
JENKINS_PORT=sys.argv[2]
USERNAME=sys.argv[3]
PASSWORD=sys.argv[4]

conn = httplib.HTTPConnection(JENKINS_IP, JENKINS_PORT)
auth = base64.b64encode(USERNAME+":"+PASSWORD).decode("ascii")
head = { 'Authorization' : 'Basic %s' %  auth }
url="http://"+JENKINS_IP+"/api/json?tree=jobs[name,color]"
conn.request("GET", url, headers = head)
    
res = conn.getresponse()
#print(res.status)
resp_str = res.read();
print(resp_str)
conn.close()
