#!/bin/bash

# Falling back to Redhat distro that works on CentOS
distro='redhat'
if [ -f /etc/os-release ]; then
    os=`gawk -F= '/^NAME/{print $2}' /etc/os-release`
    if [ "$os" = '"Amazon Linux AMI"' ]; then
        # Setup AMZN distro
        distro='amzn'
    fi
fi


# Install commen tools
yum install -y git wget telnet vim


# Setup aws-cli and aws-apitools-ec2
if [ "$distro" = 'amzn' ]; then
    yum install -y aws-cli aws-apitools-ec2
fi

# AWS-cli not installed assuming we are on CentOS
if [ "$distro" = 'redhat' ]; then
    # Install Java
    yum install -y java-1.7.0-openjdk

    # Install ec2-api-tools
    EC2_VERSION=1.7.3.0  # Current version installed in AMZN Linux (28 May 2016)
    yum install -y unzip
    wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools-$EC2_VERSION.zip
    mkdir -p /opt/aws/apitools
    unzip ec2-api-tools-$EC2_VERSION.zip -d /opt/aws/apitools
    ln -s ec2-api-tools-$EC2_VERSION/ /opt/aws/apitools/ec2
    rm ec2-api-tools-$EC2_VERSION.zip
fi


# Setup environment variables for aws-apitools-ec2
export EC2_HOME=/opt/aws/apitools/ec2
export JAVA_HOME=/usr/lib/jvm/jre
export PATH=$PATH:$EC2_HOME/bin


# Copy .bashrc to ec2-user
if [ -f /root/.bashrc ]; then
    if [ "$distro" = 'amzn' ]; then
        cp /root/.bashrc /home/ec2-user/.bashrc
    fi
    if [ "$distro" = 'redhat' ]; then
        cp /root/.bashrc /home/centos/.bashrc
    fi
fi


# Clear crontab
if [ -f /root/crontab ]; then
    rm /root/crontab
fi


# Run any installed scripts
for SCRIPT in /opt/kickstart/*; do
    if [ -f $SCRIPT -a -x $SCRIPT ]; then
        cd /;
        $SCRIPT;
    fi
done


# Install crontabs
if [ -f /root/crontab ]; then
    crontab /root/crontab
fi
