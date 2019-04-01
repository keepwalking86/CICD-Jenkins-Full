#!/bin/bash
#KeepWalking86
#Script for installing Jenkins on Ubuntu/CentOS

#Check user account to run script
if [ $UID -ne 0 ]; then
        echo "You need root account to run script"
        exit 1;
fi

if [ -f /etc/debian_version ]; then
    #Installing Jenkins on Ubuntu/Debian
    #Installing Java & Utils
    apt update -y
    apt install software-properties-common python-software-properties apt-transport-https wget -y
    add-apt-repository ppa:openjdk-r/ppa
    apt update -y
    apt install openjdk-8-jdk -y wget
    #Installing Jenkins"
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add - 
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get install jenkins -y
    #Start Jenkins
    systemctl start jenkins
    chkconfig jenkins on
    #Open port on Firewall
    ufw allow 8080

else
    if [ -f /etc/redhat-release ]; then
        ##Installing Jenkins on CentOS/RHEL
        #Installing Java & Utils
        yum install java wget -y        
        #Installing Jenkins
        wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
        rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
        yum install jenkins -y
        #Starting Jenkins
        systemctl start jenkins
        chkconfig jenkins on
        #Open port on Firewall
        firewall-cmd --permanent --zone=public --add-port=8080/tcp
        firewall-cmd --reload

    else
        echo "Distro hasn't been supported by this script"
        exit 1;
    fi
fi

echo "$(tput setaf 2)Done installing Jenkins$(tput sgr0)"
sleep 3
### Access to Jenkins Web Interface
IP_ADDR=` ip route get 1.1.1.1 | grep -oP 'src \K\S+'`
echo -e "$(tput setaf 2)Access to Jenkins Web Interface: http://$IP_ADDR:8080$(tput sgr0)"
#echo -e "Enter: $(tput setaf 1)$(cat /var/lib/jenkins/secrets/initialAdminPassword)$(tput sgr0) to Unlock Jenkins"

