#!/bin/bash

#Be sure to setup SSH key on mikrotik device to allow this to be automated

#### Get LetsEncrypt IPs
username="xxx"
router="x.x.x.x"
hostlogin="${username}@${router}"
tempfile="/var/tmp/lets.txt"
le_dns="acme-v01.api.letsencrypt.org acme-staging.api.letsencrypt.orgi acme-v02.api.letsencrypt.org acme-staging-v02.api.letsencrypt.org"  ### LetsEncrypt DNS entries

commandlist=("/ip firewall address-list remove [find where list=\"letsencrypt\"]" ) ### Remove existing entries

for x in $le_dns; do

	#$echo $x
	digresult=`dig +short $x | grep '^[.0-9]*$'`
	if [[ ! -z $digresult ]]; then
		commandlist+=("/ip firewall address-list add address=$digresult comment=\"letsencrypt\" list=letsencrypt" )
	fi
done

cat /dev/null > $tempfile   ### Create new file/blank out
for value in "${commandlist[@]}";do echo $value; echo $value >> $tempfile;done   ### write to file

echo "SSH to router: ${hostlogin}"
ssh $hostlogin < $tempfile

