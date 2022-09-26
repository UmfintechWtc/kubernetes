#!/bin/bash

# *************************************************************
# *                                                           *
# * Name: install_ansible.sh                                  *
# * Version: v0.1                                             *
# * Function:                                                 *
# *     - create yum repo on localhost                        *
# *     - install ansible and local_pip                       *
# * Create Time: 2022-02-13                                   *
# * Modify Time: 2022-02-13                                   *
# *                                                           *
# *************************************************************
#yum_version=`grep "centos7" project_url.txt | awk -v FS=',' '{print $2}'`
#pypi_version=`grep "pypi" project_url.txt | awk -v FS=',' '{print $2}'`
#YUM_FILE=./playbooks/files/third-party-software/centos7-$yum_version.tar.gz
#PIP_FILE=./playbooks/files/third-party-software/pypi-$pypi_version.tar.gz
#GHFS_FILE=./playbooks/files/third-party-software/ghfs-1.0.0.tar.gz
#PIP_REPO_FILE=~/.pip/pip.conf
#YUM_REPO_FILE=/etc/yum.repos.d/local.repo
#LOCAL_IP=`hostname -I | awk '{print $1}'`
#ANSIBLE_FORKS=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
#tar -xf $GHFS_FILE -C /usr/local/bin/

function close_ssh() {
  sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
  systemctl restart sshd

}

function install_service() {
    if [ ! -d /mnt/centos7 ]; then
        tar xf $YUM_FILE -C /mnt
    else
        rm -rf /mnt/centos7
        tar xf $YUM_FILE -C /mnt
    fi

    if [ ! -d /mnt/pypi ]; then
        tar xf $PIP_FILE -C /mnt
    else
        rm -rf  /mnt/pypi
        tar xf $PIP_FILE -C /mnt
    fi

    kill `ps aux | grep ghfs | grep -v grep | awk '{print $2}'`

    nohup ghfs -l 8000 -r /mnt &>> /mnt/start.log &

    echo "nohup ghfs -l 8000 -r /mnt &>> /mnt/start.log &" &>> /etc/rc.local
}

function install_ansible(){
    if [ ! -d "~/.pip" ]; then
        mkdir ~/.pip/
    fi

    cat > $PIP_REPO_FILE << EOF
[global]
timeout = 10
index-url =  http://mirrors.aliyun.com/pypi/simple/
extra-index-url= http://pypi.douban.com/simple/
[install]
trusted-host=
    mirrors.aliyun.com
    pypi.douban.com
EOF

    if [ ! -d "/etc/yum.repos.d_$(date +%Y)" ]; then

        mv /etc/yum.repos.d /etc/yum.repos.d_$(date +%Y)

        mkdir /etc/yum.repos.d
    fi
    cat > $YUM_REPO_FILE << EOF
[tsinghua]
name=tsinghua
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/7/os/x86_64/Packages/
enabled=1
gpgcheck=0
EOF

    # repo init
    sleep 5
    yum clean all &> /dev/null
    sleep 5
    yum repolist &> /dev/null
    sleep 5
    yum makecache &> /dev/null
    if [ $? == 0 ]; then
        echo -e "\e[32myum makecache scuccess ...\e[0m"
    else
        echo -e "\e[31myum makecache failed ...\e[0m"
    fi

    if [ $? == 0 ]; then
        yum remove ansible -y
        yum install python3-pip sshpass -y
        pip3.6 install -U pip setuptools==59.6.0
        pip3.6 install -r ./requirements.txt
    else
        echo -e "\e[31minstall ansible failed ...\e[0m"
    fi
}

#install_service
install_ansible
close_ssh