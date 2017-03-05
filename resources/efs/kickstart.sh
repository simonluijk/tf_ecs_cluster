#! /bin/bash

#Instance should be added to an security group that allows HTTP outbound
#Install jq, a JSON parser
yum -y install jq
#Install NFS client
if ! rpm -qa | grep -qw nfs-utils; then
    yum -y install nfs-utils
fi

#Get region of EC2 from instance metadata
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

#Create mount point
mkdir /mnt/efsData

#Get EFS FileSystemID attribute
#Instance needs to be added to a EC2 role that give the instance at least read access to EFS
EFS_FILE_SYSTEM_ID=`/usr/bin/aws efs describe-file-systems --region $EC2_REGION | jq '.FileSystems[]' | jq 'select(.Name=="shared_ecs")' | jq -r '.FileSystemId'`
#Check to see if the variable is set. If not, then exit.
if [ -z "$EFS_FILE_SYSTEM_ID" ]; then
	echo "ERROR: variable not set" 1> /etc/efssetup.log
else
  #Instance needs to be a member of security group that allows 2049 inbound/outbound
  #The security group that the instance belongs to has to be added to EFS file system configuration
  #Create variables for source and target
  DIR_SRC=$EC2_AVAIL_ZONE.$EFS_FILE_SYSTEM_ID.efs.$EC2_REGION.amazonaws.com
  DIR_TGT=/mnt/efsData
  #Mount EFS file system
  mount -t nfs4 $DIR_SRC:/ $DIR_TGT
  #Backup fstab
  cp -p /etc/fstab /etc/fstab.back-$(date +%F)
  #Append line to fstab
  echo -e "$DIR_SRC:/ \t\t $DIR_TGT \t\t nfs \t\t defaults \t\t 0 \t\t 0" | tee -a /etc/fstab
fi
