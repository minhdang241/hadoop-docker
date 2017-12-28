#!/bin/bash

#ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 0600 ~/.ssh/authorized_keys


service ssh start 

cd /usr/local/hadoop/sbin/
#./start-dfs.sh
#./start-yarn.sh

export HADOOP_HOME=/usr/local/hadoop/
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop

./hadoop-daemon.sh  --script hdfs start namenode
./start-yarn.sh
./mr-jobhistory-daemon.sh --config $HADOOP_CONF_DIR start historyserver
cd ~

/bin/bash

