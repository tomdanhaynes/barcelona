#!/bin/bash
#OLDPASSWD=$2
#NEWPASSWD=$3
#USERNAMES=$1


curl -u $1:$2 -i -H 'X-Requested-By: ambari' -X PUT -d '{   "Users": {"user_name": "'$1'","old_password": "'$2'","password": "'$3'" }}' http://`hostname -f`:8080/api/v1/users/username

