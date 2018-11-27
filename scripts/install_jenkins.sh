#!/bin/bash
#KeepWalking86
#Script for installing Jenkins on Ubuntu/CentOS

if [ -f /etc/debian_version ]; then
    #Installing Jenkins on Ubuntu/Debian
    #Installing Java
    sudo apt update -y
    sudo apt install software-properties-common python-software-properties apt-transport-https -y
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt update -y
    sudo apt install openjdk-8-jdk -y
    #Installing Jenkins"
    wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - 
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install jenkins -y
    #Restart Jenkins
    systemctl restart jenkins
    #Open port on Firewall
    sudo ufw allow 8080

else
    if [ -f /etc/redhat-release ]; then
        ##Install Jenkins on CentOS/RHEL
        sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
        sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
        sudo yum install jenkins -y
        #Install Java
        sudo yum install java -y
        sudo systemctl start jenkins
        sudo chkconfig jenkins on
        #Open port on Firewall
        sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
        sudo firewall-cmd --reload

    else
        echo "Distro hasn't been supported by this script"
        exit 1;
    fi
fi

echo "Done installing Jenkins"
sleep 3
### Access to Jenkins Web Interface
IP_ADDR=` ip route get 1.1.1.1 | grep -oP 'src \K\S+'`
echo -e "Access to Jenkins Web Interface: http://$IP_ADDR:8080"