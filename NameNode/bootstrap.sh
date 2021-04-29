#!/bin/bash

#ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 0600 ~/.ssh/authorized_keys


service ssh start 

cd /usr/local/hadoop/sbin/
#./start-dfs.sh
#./start-yarn.sh

export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop

# ${HADOOP_HOME}/bin/hdfs --daemon start namenode
echo 'N' | /usr/local/hadoop/bin/hdfs namenode -format
./start-dfs.sh
./start-yarn.sh
${HADOOP_HOME}/bin/mapred --daemon start historyserver
cd ~

tail -f /dev/null
