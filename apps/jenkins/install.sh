#!/bin/bash -xe

if [ $EUID != 0 ]; then
    echo "This script must be run as root, use sudo $0 instead" 1>&2
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt -y install openjdk-8-jdk

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update && apt install -y jenkins


### install plugins
### from: https://gist.github.com/chuxau/6bc42f0f271704cd4e91
bash -xe $DIR/get-plugins.sh $DIR/plugins.txt $DIR/plugins
sudo -u jenkins rsync -rv $DIR/plugins/ /var/lib/jenkins/plugins/


### restart jenkins to load plugins
systemctl restart jenkins