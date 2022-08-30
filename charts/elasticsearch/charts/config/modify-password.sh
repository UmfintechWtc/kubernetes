#!/bin/bash
chown -R es:es logs/ data/
su es -c "bin/elasticsearch -d"
while true
do
sleep 1
if nc -w1 -z localhost 9200;then
   sleep 5
   echo elasticsearch has started

   if curl -u $ES_USERNAME:$ES_PASSWORD localhost:9200 | grep "You Know, for Search";then
       echo -e "\npassword is right, needn't to modify"
       exit
   else
       echo password is fault
       echo start to modify password

       if ! curl -u copriwolf:sayHi2Elastic  -XPUT "http://localhost:9200/_xpack/security/user/$ES_USERNAME/_password?pretty" -H 'Content-Type:application/json' -d '{"password": "'$ES_PASSWORD'"}';then
           echo "failed to modify password"
           echo "initcontainer running failed,because failed to modify password,unexpected exited"
           exit 1 
       fi
       bin/elasticsearch-users userdel copriwolf
       sleep 10
        
       if curl -u $ES_USERNAME:$ES_PASSWORD localhost:9200 | grep "You Know, for Search" ;then
           echo password modified successfully
           exit
       else
           echo "initcontainer running failed, because password modified successfully but can't get right response with useing the password,unexpected exited"
           exit 1
       fi
    fi
fi

done
