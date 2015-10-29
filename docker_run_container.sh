#!/bin/bash

read -r -p "Would you like to initialize new containers? [y/n]" response

if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo 'Erasing containers...'
    docker stop $(docker ps -a | grep 'metabase_' | awk '{ print $1 }')
    docker rm $(docker ps -a | grep 'metabase_' | awk '{ print $1 }')
else
    docker restart $(docker ps -a | grep 'metabase_' | awk '{ print $1 }')
    sleep 5
    docker restart $(docker ps -a | grep 'metabase_' | awk '{ print $1 }')
    docker ps -a
    exit 0
fi

echo 'Initializing Metabase Container ...'

docker run -d -p 3000:3000 -p 2222:22 --name metabase_3000 metabase.centos6 
sleep 5
docker run -d -p 3001:3000 -p 2223:22 --name metabase_3001 metabase.centos6
sleep 5
docker ps -a
