#!/bin/bash
#

> /tmp/jobs_json
> /tmp/jen_json

echo "Checking requirements ..."
jq --version> /dev/null 2>&1
if [ $? != "0" ]
then
	echo "jq not installed"
fi

echo "Fetching variables ..."
if [ -f variables.json ]
then
	JENKINS_IP=`jq -r '.JENKINS_IP' variables.json`
	JENKINS_PORT=`jq -r '.JENKINS_PORT' variables.json`
	USERNAME=`jq -r '.USERNAME' variables.json`
	PASSWORD=`jq -r '.PASSWORD' variables.json`
else
	echo "variable file is missing"
	exit
fi

if [[ ! -n $JENKINS_IP || ! -n $JENKINS_PORT || ! -n USERNAME || ! -n PASSWORD ]]
then
	echo "one or more variables cannot be determined"
	exit
fi

echo "Creating a new report ..."
echo "Job;Build Id; Build Status; Job Start; Job End" > reports.csv
python getjoblist.py $JENKINS_IP $JENKINS_PORT $USERNAME $PASSWORD > /tmp/jobs_json
for jobname in `jq -r '.jobs[].name' /tmp/jobs_json`
do
python jenkinsdata.py $jobname $JENKINS_IP $JENKINS_PORT $USERNAME $PASSWORD > /tmp/jen_json
for jid in `jq -r '.builds[].id' /tmp/jen_json`
do
jobstat=`jq -r --arg jid "$jid" '.builds[]| select(.id==$jid) | .result' /tmp/jen_json`
#echo $jobstat
start=`jq -r --arg jid "$jid" '.builds[]| select(.id==$jid) | .timestamp' /tmp/jen_json`
duration=`jq -r --arg jid "$jid" '.builds[]| select(.id==$jid) | .duration' /tmp/jen_json`
jstart=`python gettime.py $start $duration|head -1`
jend=`python gettime.py $start $duration|tail -1`
echo "$jobname;$jid;$jobstat;$jstart;$jend" >> reports.csv
done
done
echo "Report generation completed"
