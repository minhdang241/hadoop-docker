#!/bin/bash



service ssh start 

cd /usr/local/hadoop/bin/

#add namenode hostname so data nodes can find it
#echo "192.168.1.30 namenode.pubnet" >> /etc/hosts

export HDFS_NAMENODE_OPTS="-Xmx10g"

./hdfs --daemon start datanode

cd ~

tail -f /dev/null
