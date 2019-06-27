#/bin/bash -xe

if [ $EUID != 0 ]; then
    echo "This script must be run as root, use sudo $0 instead" 1>&2
    exit 1
fi

if [ -z "$1"]; then
    DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)"
else
    DOCKER_COMPOSE_URL="$1"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

### install docker
if [ ! -f $DIR/get-docker.sh ]; then
    curl -fsSL https://get.docker.com -o $DIR/get-docker.sh
fi
sh $DIR/get-docker.sh --mirror Aliyun


### install docker-compose
if [ ! -f $DIR/docker-compose-Linux-x86_64-1.24.0 ]; then
    curl -L $DOCKER_COMPOSE_URL -o /usr/local/bin/docker-compose
else
    cp $DIR/docker-compose-Linux-x86_64-1.24.0 /usr/local/bin/docker-compose
fi
chmod +x /usr/local/bin/docker-compose


### add registry mirror
cp $DIR/daemon.json /etc/docker/daemon.json
systemctl restart docker