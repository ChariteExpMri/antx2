#!/bin/bash
 
# CLEAR SCREEN
printf "\033c"

#if [ "$1" == "-h" ]; then
if [ "$1" == "-h" ] || [ -z "$1" ]; then


 

 echo 'Usage: `basename $0` [somestuff]'
 echo '------------------------------------------------'
 echo 'input args: '
 echo 'arg1: GOOGLE-ID                            EXAMPLE: "1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ"'
 echo 'arg2: OUTFILEname                          EXAMPLE: "/home/klaus/Documents/tests/test2/t3.zip"'
 echo 'arg3: HTTP_PROXY (optional)  : proxy+port, EXAMPLE: http://proxy.charite.de:8080'
 echo 'arg4: HTTPS_PROXY (optional) : proxy+port, EXAMPLE: http://proxy.charite.de:8080'
 echo '*** RUNNING FROM MATLAB NO PROXIES: ***'
 echo '!./getFileGdrive.sh "1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ" "/Users/skoch/Documents/mac_stuff/data1/test_download/t3.zip"'
 echo '*** RUNNING FROM MATLAB WITH PROXIES: ***'
 echo '!./getFileGdrive.sh "1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ" "/Users/skoch/Documents/mac_stuff/data1/test_download/t3.zip" http://proxy.charite.de:8080'
 echo '!./getFileGdrive.sh "1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ" "/Users/skoch/Documents/mac_stuff/data1/test_download/t3.zip" http://proxy.charite.de:8080  https://proxy.charite.de:8080'

 echo '------------------------------------------------'

# worked: !./getFileGdrive.sh "1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ" "/Users/skoch/Documents/mac_stuff/data1/test_download/t3.zip" https://proxy.charite.de:8080  http://proxy.charite.de:8080
# worked  !./getFileGdrive.sh "1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ" "/Users/skoch/Documents/mac_stuff/data1/test_download/t3.zip" proxy.charite.de:8080 proxy.charite.de:8080
 
 exit 1
fi




fileid=$1
filename=$2
http_proxy=$3
https_proxy=$4

check=0;
if [ $check -eq 1 ];
  then
   echo $fileid
   echo $filename
   echo $http_proxy
   echo $https_proxy
fi

echo '  '

# --------PROXY ----------------------------------------


# echo $fileid
# echo $filename
# echo $proxy

set

# ---------------------- HTTPS

if [ -z "$4" ]
  then
    echo "[https_proxy]: 0"
    unset https_proxy
else
   
   export https_proxy=$4
   echo [https_proxy]: 1 ... is: ["$https_proxy"]
fi


# ---------------------- HTTP
if [ -z "$3" ]
  then
    echo "[ http_proxy]: 0"
   unset http_proxy
els
    export http_proxy=$3
    echo [http_proxy]: 1 ... is: ["$http_proxy"]
fi




#exit 1

# --------CURL ----------------------------------------


# export https_proxy=http://proxy.charite.de:8080
# fileid="1UlbnFOZzrUurq1-7B40jnTUoWCnwqjDZ"
# filename="/home/klaus/Documents/tests/test2/that.zip"

curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}


echo ------info------------------
echo "curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null"
echo "curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}"




