#!/bin/bash

rm -f /backups/backuplog-*.txt
d=`date +%Y-%d-%m--%H-%M-%S`
echo $d > /backups/backuplog-$d.txt

backup () {
	rsync -ra --update --delete --progress $1/ /backups$1 |& tee -a /backups/backuplog-$d.txt
	if [ $? -eq 0 ] ; then
		echo -e "\e[93m$1 Success\e[0m"
		echo " " >> /backups/backuplog-$d.txt
		echo "$1 Success" >> /backups/backuplog-$d.txt
	else
		echo -e "\e[31m$1 Fail\e[0m"
		echo " " >> /backups/backuplog-$d.txt
		echo "$1 Fail" >> /backups/backuplog-$d.txt
	fi
}

#home
backup /home

#etc
backup /etc

#servers
backup /servers

#var (VMs)
backup /var


#spins down drive when done
hdparm -y /dev/disk/by-uuid/c506cb21-52f8-4035-9604-b0604524f219
