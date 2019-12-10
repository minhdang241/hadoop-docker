#!/bin/bash



service ssh start 

cd /usr/local/hadoop/sbin/

#add namenode hostname so data nodes can find it
#echo "192.168.1.30 namenode.pubnet" >> /etc/hosts

export HADOOP_DATANODE_OPTS="-Xmx10g"

./hadoop-daemon.sh  --script hdfs start datanode

cd ~

/bin/bash

