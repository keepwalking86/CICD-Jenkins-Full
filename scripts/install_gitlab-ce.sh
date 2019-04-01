#!/bin/bash
#KeepWalking86
#Installing GitLab-CE on Ubuntu/CentOS
DOMAIN_GITLAB=gitlab.example.local

#Check user account to run script
if [ $UID -ne 0 ]; then
        echo "You need root account to run script"
        exit 1;
fi

#Check OS and install
if [ -f /etc/debian_version ]; then
    #Installing required packages and open http/https on firewall
    apt-get update
    apt-get install -y curl openssh-server ca-certificates
    ufw allow http
    ufw allow https
    #Add gitlab repo on Ubuntu
    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash
    #URL for GitLab
    EXTERNAL_URL="http://${DOMAIN_GITLAB}" apt-get install gitlab-ce
else
    if [ -f /etc/redhat-release ]; then
        #Installing required packages and open http/https on firewall
        yum install -y curl policycoreutils-python openssh-server
        systemctl enable sshd
        systemctl start sshd
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        systemctl reload firewalld
        #Add gitlab repo on CentOS/RedHat
        curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
        #URL for GitLab
        EXTERNAL_URL="http://${DOMAIN_GITLAB}" yum install -y gitlab-ce
    else
        echo "Distro hasn't been supported by this script"
        exit 1;
    fi
fi

#Setting mail
echo "$(tput setaf 3)Replacing your mail setting informations$(tput sgr0)"
sleep 4
cat >>/etc/gitlab/gitlab.rb <<EOF
 gitlab_rails['smtp_enable'] = true
 gitlab_rails['smtp_address'] = "mail.vnsys.wordpress.com"
 gitlab_rails['smtp_port'] = 25
 gitlab_rails['smtp_user_name'] = "notify@vnsys.wordpress.com"
 gitlab_rails['smtp_password'] = "ILoveYou"
 gitlab_rails['smtp_domain'] = ""
 gitlab_rails['smtp_authentication'] = "login"
 gitlab_rails['smtp_enable_starttls_auto'] = true
 gitlab_rails['smtp_tls'] = false
EOF

#Restart gitlab-ce
gitlab-ctl reconfigure

### Access to GitLab Web Interface
IP_ADDR=` ip route get 1.1.1.1 | grep -oP 'src \K\S+'`
echo -e "$(tput setaf 2)Access to GitLab Web Interface: http://$IP_ADDR$(tput sgr0)"
