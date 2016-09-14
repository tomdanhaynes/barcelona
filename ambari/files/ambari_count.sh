#!/bin/bash 

# Script to return the number of $1/$2 combinations from ambari. 

ClusterName=$(curl -s http://admin:admin@localhost:8080/api/v1/clusters | grep 'cluster_name' | awk -F\" ' { print $4 } ') 
curl -s http://admin:admin@localhost:8080/api/v1/clusters/$ClusterName/services/$1 | grep "$2" | awk -F ":" ' { print $2 } ' | tr -d "[, ]"

