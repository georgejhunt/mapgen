#!/bin/bash -x
# Recreate the map source bundle, and merge in the regional vector subsets

# first check that the environment has been set
MG=${MG_SSD}
if [ "$MG" == "" ];then
   echo "Have you set the environment variables via 'source ./setenv'"
   exit 1
fi

# copy the extracted mbtiles to the $MG_HARD_DISK, perhaps free up MG_SSD
for EXTRACT in $(ls $MG_SSD/output/stage2/*.mbtiles); do
   if [ ! -f $MG_HARD_DISK/output/stage3/$EXTRACT ]; then
      cp -f $MG_SSD/output/stage2/$EXTRACT $MG_HARD_DISK/output/stage3/$EXRACT
   fi
   # Free up SSD if flag is set
   if [ "$FREE_SSD" ==  'true' ]; then
      rm -f $EXTRACT
      touch $EXTRACT
   fi
done


# the following script downloads all the resources to start3/fromscratch
if [ ! -d $MG_HARD_DISK/output/stage3/fromscratch ];then
	$MG_SSD/mk-osm-min
fi

# when done move the build directory out of the way
if [ -d $MG_HARD_DISK/output/stage3/fromscratch/build ]; then
   mv $MG_HARD_DISK/output/stage3/fromscratch/build $MG_HARD_DISK/output/stage3/
fi
 
# use python to read the mbtiles metadata, and update regions.json
$MG_SSD/update_regions.json.py

# use python to read the region.json, and assemble the packages

$MG_SSD/mk_map_packages.py

