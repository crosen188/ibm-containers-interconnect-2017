#!/bin/bash

if [ -z $1 ]
then
    echo ""
    echo "URL wasn't passed as an arguement - please pass the URL that was given to you when you deployed the initial application"
    echo ""
    exit 1
fi

echo curl ${1}/index.txt
while :
do
    curl ${1}/index.txt
    sleep 5
done
