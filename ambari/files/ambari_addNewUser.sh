#!/bin/bash
#USERNAME=$1
#PASSWD=$2
#ADMIN=$3
#ADMIN USERNAME$4
#ADMIN PASSWD=$5

curl -u $4:$5 -i -H 'X-Requested-By: ambari' -X POST -d '{"Users/user_name": "'$1'","Users/password":  "'$2'","Users/active": true,"Users/admin": '$3'}' http://`hostname -f`:8080/api/v1/users
