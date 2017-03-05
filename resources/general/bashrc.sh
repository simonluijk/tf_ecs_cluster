# .bashrc

export EC2_HOME=/opt/aws/apitools/ec2
export JAVA_HOME=/usr/lib/jvm/jre
export PATH=$PATH:$EC2_HOME/bin

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

alias conn='netstat -an | grep ESTABLISHED'
alias ecslogin='`aws ecr get-login --region us-west-2`'

function dps { docker ps | grep "$1"; }
function dbs { docker exec -it "$1" /bin/bash; }
function djs { docker exec -it "$1" python manage.py; }
