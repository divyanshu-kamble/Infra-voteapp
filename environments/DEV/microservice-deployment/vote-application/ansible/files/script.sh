#!/bin/bash
APPNAME=$1

#Check for depenedincies of redis and postgres

#Using key value pair - TO ITERATE OVER THE REQUIRED DEPENDENCIES AND THEN RUNNING THE CONTAINERS
declare -a CONTAINER_NAME


CONTAINER_NAME[redis:latest]="docker run -d -h redis -p 6379:6379 --name redis redis:latest"
CONTAINER_NAME[postgres:15-alpine]="docker run -d -h db --name postgres -e POSTGRES_DB=db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:15-alpine"
CONTAINER_NAME[$APPNAME]="docker run -d -p 5000:80 --link redis --name $APPNAME divyanshuk/$APPNAME"


#ITERATING OVER THE CONTAINER_NAME AND INSTALLING OR STARTING THE CONTAINERS
for container in "${!CONTAINER_NAME[@]}"

do
    echo "$container"
    container_info=$(docker ps -a --filter "ancestor=$container" --format "{{.Names}}:{{.State}}")
    echo "$container_info"
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
            echo "will install $container_name"
            eval ${CONTAINER_NAME[$container]}
            # eval $DOCKER_COMMAND
            # docker run -d -p 5000:80 --link redis --name vote divyanshuk/$1
        fi
    else
        echo "No containers found using the specified image $container_name"
        eval ${CONTAINER_NAME[$container]}
        # eval $DOCKER_COMMAND
    fi
done
