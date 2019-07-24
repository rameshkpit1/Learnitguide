#!/bin/bash
logfile=dockerimage.log

cat > dockerfile << EOF

FROM docker.io/python:latest

MAINTAINER selvakumar0710@gmail.com

RUN apt-get update && apt-get -y upgrade python

EOF

docker build -t mypython:latest . > $logfile
echo "Logs of docker image creations are stored in the file : $logfile"
