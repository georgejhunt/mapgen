#!/bin/bash -x
# Zip up the bundles and transfer them to location where they will be published

# first check that the environment has been set
MG=${MG_SSD}
if [ "$MG" == "" ];then
   echo "Have you set the environment variables via 'source ./setenv'"
   exit 1
fi

URL_TARGET=$MAP_DL_URL
pushd $MG_HARD_DISK/output/
for package in $(ls stage4*); do
   echo $package|grep zip
   if [ $? -eq 0 ];then continue; fi
   if [ $(ls $package.zip ) -ne 0 ]; then
      zip -ry ${package}.zip $package
   fi   
   resp=$(curl -s --head http://$URL_TARGET/$package.zip | grep HTTP | cut -d' ' -f2)
   case $resp in
   200 | 301)  ;;
   *) cp $package.zip $MAP_UPLOAD_TARGET
   ;;
   esac
done
popd
