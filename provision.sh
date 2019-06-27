#!/bin/bash -xe

if [ $EUID != 0 ]; then
    echo "This script must be run as root, use sudo $0 instead" 1>&2
    exit 1
fi

export PROVISION_DIR=/vagrant
export USER=vagrant


### fix slow DNS
systemctl stop systemd-resolved.service
systemctl disable systemd-resolved.service
rm -f /etc/resolv.conf
cp $PROVISION_DIR/configs/resolv.conf /etc/resolv.conf


### use Aliyun mirrors 
cp $PROVISION_DIR/configs/sources.list /etc/apt/sources.list
apt update && apt install -y curl


### add user
# adduser dio --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
# usermod -aG sudo dio
# echo dio:THEWORLD | chpasswd


### install docker and docker-compose
DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)"
source /vagrant/apps/docker/install.sh $DOCKER_COMPOSE_URL


### install jenkins
source /vagrant/apps/jenkins/install.sh

### add jenkins to docker group
usermod -aG docker jenkins


### add vagrant to docker group, avoid `sudo docker`
usermod -aG docker $USER