export EC2_HOME=/opt/aws/apitools/ec2
export JAVA_HOME=/usr/lib/jvm/jre

export INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
export APP_TAG=$(/opt/aws/apitools/ec2/bin/ec2dtag --region us-west-2 --filter "key=Name" --filter "resource-type=instance" --filter "resource-id=$INSTANCE_ID" | grep -oE "Name\\W+(.+)$" | grep -oE "\\W.+$")
export APP_TAG=$(echo  $APP_TAG | sed -e 's/^ *//' -e 's/ *$//')
export PS1="\u@$APP_TAG:\w> "
