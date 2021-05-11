# HOW TO RUN ON SERVER
Step1: Run the namenode container and datanode container(s) using docker compose

```
docker-compose up --scale datanode=3
```

1. Check log
`cd /usr/local/hadoop/logs`

2. Access Resource Manager
`http://localhost:8088/cluster`

3. Access Web UI
`http://localhost:9870`
