#!/bin/bash

#ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 0600 ~/.ssh/authorized_keys


service ssh start 

cd /usr/local/hadoop/sbin/
#./start-dfs.sh
#./start-yarn.sh

#add namenode hostname so data nodes can find it
echo "192.168.1.30 namenode.pub_net" >> /etc/hosts

./hadoop-daemon.sh  --script hdfs start datanode

cd ~

#/bin/bash

