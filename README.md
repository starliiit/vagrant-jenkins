# vagrant-jenkins

A vagrant box based on [generic/ubuntu1804](https://app.vagrantup.com/generic/boxes/ubuntu1804), with docker, docker-compose and jenkins(with some plugins).

## Why this box

I tried the official jenkins docker image, pretty nice but when I want to run my builds in a docker container, I have to try those *DinD* or *DooD* hacks. Not that trivial. So I turned back to VM solutions. 

Anyway, it's not very likely that I'll spin up and destroy Jenkins that often.

## Usage

1. `vagrant up`
2. Enter the network interface you want to bridge on. Or if you don't want to use `public_network`, modify settings in `Vagrantfile`.
3. Wait for provision to finish.
4. (optional) Use `vagrant package` to export the box.

## Some customizations 

I made some customizations based on my needs, you may take a look before you `vagrant up`.

### `systemd-resolved` is disabled

At first I just pulled generic/ubuntu1804 without any configuration. Network was **SLOW AS FUCK**. 

I found that `nslookup www.yahoo.com` takes 2 seconds, but [changing DNS settings to NAT](https://serverfault.com/questions/495914/vagrant-slow-internet-connection-in-guest) mode didn't help.

After some failed attempt I disabled `systemd-resolved` and directly added nameserver record in `/etc/resolv.conf`, problem solved. 

Still don't know the reason for that. I tried Virtualbox GUI with official Ubuntu ISO, `systemd-resolved` worked just fine.

Custom `resolv.conf` is in `configs/resolv.conf`.

### Custom `sources.list` for apt

I use Aliyun.

Custom `sources.list` is in `configs/sources.list`.

### Install Jenkins plugins in batch

Installation script taken from [this gist](https://gist.github.com/chuxau/6bc42f0f271704cd4e91).

You can checkout `apps/jenkins/plugins.txt` to add plugins you want to install.

Remember to add a blank line after the last plugin because there seems to be a bug in the installation script.

### Custom registry for docker

Custom `daemon.json` in `apps/docker/daemon.json`.

### Custom `docker-compose` binary URL

Downloading from Github release is too slow for me, so I uploaded the binary to the internal storage of my organization and downloaded from there.

If you want to do the same thing, you can change `DOCKER_COMPOSE_URL` in `provision.sh`.