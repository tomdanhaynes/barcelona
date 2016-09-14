#!/bin/bash
ACCESS=$1 #CLUSTER.READ
USERNAME=$2 #admin
USERTYPE=$3 #USER


curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '[ {"PrivilegeInfo": {"permission_name":"$1","principal_name":"$2","principal_type":"$3" }} ]' http://`hostname -f`:8080/api/v1/users/username


#curl -u adminpassword -i  -H "X-Requested-By: ambari" -X GET  http://`hostname -f`:8080/api/v1/clusters/|echo $? == 0
~                
