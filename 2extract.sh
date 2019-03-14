#!/bin/bash -x
# stimulate the openmaptiles/extracts to generate extracts

# first check that the environment has been set
MG=${MG_SSD}
if [ "$MG" == "" ];then
   echo "Have you set the environment variables via 'source ./setenv'"
   exit 1
fi


cd $MG_SSD/extracts
$MG_SSD/extracts/create-extracts.sh

