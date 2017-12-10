# Distributed HADOOP on Docker containers


## This project contains two Dockerfiles to builds Hadoop Namenode and Datanodes.
This is very similar to my other repositury that builds and runs [Hadoop on a single container](https://github.com/feorean/single_node_hadoop_docker) 

NOTE: I have not included hadoop instalation file as it big (too big for image rebuilds). But you can download it from [Apache web site](http://hadoop.apache.org/releases.html).

Dowload and save hadoop to the subfolders, one per directory (e.g. NameNode/hadoop-2.8.2.tar.gz and DataNode/hadoop-2.8.2.tar.gz). 

I am using 2.8.2 version but feel free to download the other version and don't forget to update Dockerfile respectevely.

There are few important changes needs to be done if there is a need to change below addresses i.e. IP's or PORTS
(NOTE: below chnages neeeds to be done both Namenode and Datanodes)

Set Hadoop to distributed mode and update Namenode fsimage path in hdfs-site.xml file:
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

Then you can update Namenode default address in core-site.xml:
```
<configuration>

    <property>
        <name>io.file.buffer.size</name>
        <value>131072</value>
    </property>

    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://192.168.1.5:9000</value>
    </property>

</configuration>
```

##Building images

And then you can build images with following command:

```
cd NameNode
sudo docker build -t namenode:0.2 .
cd ../DataNode
sudo docker build -t datanode:0.2 .
```

For connectivity and web interface access I am using here MACVLAN virtualisation so it allows me to set my local network IP to the container and allows access to Hadoop web interfaces easily. 

##Network configuration

create MACVLAN network/interface

```
sudo docker network create -d macvlan     --subnet=192.168.1.0/24     --gateway=192.168.1.1      -o parent=eth0 pubnet
```

##Starting the cluster

Run Namenode with static IP and bind local path to persist fsimage file for reloads
```
docker run \
	--name namenode \
	-v  "/home/khalid/docker/hadoop_dist.img/NameNode/namenodedata/:/usr/data/hdfs/namenode/" \
	-it \
	--net=pubnet --ip=192.168.1.5 namenode:0.2 

```

Then run few datanodes (7 to be precise)
```
for i in {10..16}
do  
  echo "docker run -it -d --net=pubnet --ip=192.168.1.$i datanode:0.2"
done
```

Then you can access NameNode info on

```
http://192.168.1.5:50070
```

And Yarn (Resource Manager) on

```
http://192.168.1.5:8088/cluster/cluster
```


Please note that above URLs will only work if you try to access it from different host. i.e. not from host machine where docker runs!

See notes on  MACVLAN documentation on [docker docs](https://docs.docker.com/engine/userguide/networking/get-started-macvlan/#macvlan-bridge-mode-example-usage)

But you can fix it using suggested solution on that page i.e. replace you host's network interface with MACVLAN interface. See note: [Communication with the Docker host over macvlan]
(https://docs.docker.com/engine/userguide/networking/get-started-macvlan/#macvlan-bridge-mode-example-usage)






