from __future__ import print_function
import base64
import string
import httplib
import json
import os
import sys

JENKINS_JOB_NAME=sys.argv[1]
JENKINS_IP=sys.argv[2]
JENKINS_PORT=sys.argv[3]
USERNAME=sys.argv[4]
PASSWORD=sys.argv[5]


conn = httplib.HTTPConnection(JENKINS_IP, JENKINS_PORT)
auth = base64.b64encode(USERNAME+":"+PASSWORD).decode("ascii")
head = { 'Authorization' : 'Basic %s' %  auth }
url="http://"+JENKINS_IP+"/job/"+JENKINS_JOB_NAME+"/api/json?tree=builds[number,status,timestamp,id,result,duration]"
conn.request("GET", url, headers = head)
    
res = conn.getresponse()
#print(res.status)
resp_str = res.read();
print(resp_str)
conn.close()
