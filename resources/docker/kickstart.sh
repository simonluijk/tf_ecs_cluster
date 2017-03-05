#!/bin/bash

# Setup docker cleanup script
if [ -f /opt/docker_cleanup.sh ]; then
    echo "$(( RANDOM % 60 )) 3 * * * /opt/docker_cleanup.sh" >> /root/crontab
fi

sysctl -w vm.max_map_count=262144
echo "" >> /etc/sysctl.conf
echo "#Give ample virtual memory for mmapped files" >> /etc/sysctl.conf
echo "vm.max_map_count = 262144" >> /etc/sysctl.conf

# Restart docker so data gets written to mounted volumes and not the 
# root file system.
service docker stop
sleep 30s
service docker start
