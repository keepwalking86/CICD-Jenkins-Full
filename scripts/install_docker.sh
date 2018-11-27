#!/bin/bash
#KeepWalking86
#Script for installing docker, docker-compose (Ubuntu/CentOS)

#Installing Docker
curl -sSL https://get.docker.com/ | sudo sh
#Add user to docker group
sudo usermod -aG docker `whoami`
#Start docker daemon
sudo systemctl start docker.service
sudo systemctl enable docker.service

#Install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#Enable Docker command-line auto completion
if [ -f /etc/debian_version ]; then
    sudo apt-get update
    sudo apt-get install bash-completion
else
    if [ -f /etc/redhat-release ]; then
        sudo yum -y install bash-completion
    else
        echo "Distro hasn't been supported by this script"
        exit 1;
    fi
fi
#Download bash completion file into /etc/bash_completion.d
sudo curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh