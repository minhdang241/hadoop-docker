# Distributed HADOOP on Docker containers

## Overview

In this article I will set up distributed Hadoop cluster based on Docker containers. For networking I will use user defined BRIDGE network that will segregate the cluster and will allow easy communication between nodes.
Set up

First clone repository I have created for this article:
```
cd ~
mkdir hadoop_dist
cd hadoop_dist
git clone https://github.com/khalidmammadov/hadoop_dist_docker.git
```
Dowload and save hadoop to the subfolders, one per directory (e.g. NameNode/hadoop-2.8.2.tar.gz and DataNode/hadoop-2.8.2.tar.gz). I am using 2.8.2 version but feel free to download the other version and don’t forget to update Dockerfile respectevely.
```
wget http://apache.mirror.anlx.net/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz
cp hadoop-2.8.2.tar.gz NameNode
cp hadoop-2.8.2.tar.gz DataNode
```
## Make changes in configurations (Optional)

Set Hadoop to distributed mode and replication factor and update Namenode fsimage path in hdfs-site.xml file:

```
<configuration>

    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>

    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/usr/data/hdfs/namenode</value>
    </property>

    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/usr/data/hdfs/datanode</value>
    </property>


    <property>
        <name>dfs.blocksize</name>
        <value>10485760</value>
    </property>


</configuration>
```
Then update Namenode’s Container address (this will be defined during container’s run-time) on  in core-site.xml:
```
<configuration>

    <property>
        <name>io.file.buffer.size</name>
        <value>131072</value>
    </property>

    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://namenode:9000</value>
    </property>

</configuration>
```
## Building images

Now you can build images with following commands:
```
cd NameNode
sudo docker build -t namenode:0.1 .
cd ../DataNode
sudo docker build -t datanode:0.1 .
```
## Starting the cluster

Run Namenode with specific name as that one set up for Datanodes to point at and bind local path to persist fsimage file for reloads
```
docker run \
	--name namenode \
	-v  "/home/khalid/docker/hadoop_dist.img/NameNode/namenodedata/:/usr/data/hdfs/namenode/" \
    -p 50070:50070 \
    -p 9000:9000 \
    -p 8088:8088 \
    -p 50030:50030 \
    -p 50060:50060 \
	-dit \
	--network="hadoop.net" \
        namenode:0.1 
```
Then run few datanodes (7 to be precise)
```
for i in {1..7}
do  
  docker run --name=datanodes$i -dit --network=hadoop.net datanode:0.1
done
```
To check if all up and running we need to obtain IP address of the Namenode. For that we need to run below docker command and look for our container named “namenode” as per below:
```
`~/docker/hadoop_dist.img$ docker network inspect hadoop.net`


# HOW TO RUN ON SERVER
Step1: run namenode container
```
docker run \
        --name namenode \               
        -v  "/home/minhdang/hadoop_tutorial/hadoop_dist_docker/NameNode/namenodedata/:/usr/data/hdfs/namenode/" \
        -dit \
        --network="hadoop.net" \
        namenode:0.1
```

Step2: Validate the namenode
```docker exec -it namenode /bin/bash```

Step3: Run the namenode container and datanode container(s) using docker compose
```
docker-compose up --scale datanode=3
```

1. Check log
`cd /usr/local/hadoop/logs`

2. Access Resource Manager
`http://localhost:8088/cluster`

3. Access Web UI
`http://localhost:9870`
