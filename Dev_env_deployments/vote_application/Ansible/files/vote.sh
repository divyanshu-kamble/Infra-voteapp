#!/bin/bash


container_info=$(docker ps -a --filter "ancestor=$1" --format "{{.Names}}:{{.State}}")
# echo "$container_info"
#Check if the output of the container is not null
if [ -n "$container_info" ]; then
    container_name=$(echo "$container_info" | cut -d':' -f1)
    container_status=$(echo "$container_info" | cut -d':' -f2)

    if [ "$container_status" == "running" ] ; then
        echo "Container $container_name is up and running"
    elif [ "$container_status" == "exited" ]; then
        echo "Container $container_name is in exited state"
        # If the container is in exited state then start the container
        docker start $container_name
    else
        echo "will install"
        docker run -d -p 5000:80 --link redis --name vote divyanshuk/$1
 
    fi
else
    echo "No containers found using the specified image"
    docker run -d -p 5000:80 --link redis --name vote divyanshuk/$1
fi
