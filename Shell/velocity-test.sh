#!/bin/bash

mkfifo /tmp/pipe
java -jar proxy.jar < /tmp/pipe

while :
do
    servers = curl https://mpde7t08k1.execute-api.ap-southeast-2.amazonaws.com/prod/minecraft/server/getserver?key=NqpKKL4K93VtCt9vS4ndKqxWE9mWvVsTVfzh | jq -rc '.[]'
    config = ""
    for server in servers; 
    do
        server = echo server | sed -e 's/^.............//' | sed -e 's/..$//'
        name = server | sed -e 's/^.............//' | sed -e 's/..$//' | cut -d = -f1
        ip = server | sed -e 's/^.............//' | sed -e 's/..$//' | cut -d = -f2

    done
    echo "velocity reload" > /tmp/pipe
    sleep 15
done

{"ServerId":{"S":"Creative = 13.236.208.248"}}
