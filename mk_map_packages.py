#!/usr/bin/env  python
# Output the regions in regions.json

import os,sys
import json
import shutil

# error out if environment is missing
MG_SSD = os.environ["MG_SSD"]
REGION_INFO = os.path.join(MG_SSD,'regions.json')
REGION_LIST = os.environ.get("REGION_LIST")
#print(REGION_LIST)
REGION_LIST = json.loads(REGION_LIST)

MG_HARD_DISK = os.environ.get("MG_HARD_DISK",'/hd/mapgen')
MAP_DATE = os.environ.get("MAP_DATE",'2019-03-09')
MAP_VERSION = os.environ.get("MAP_VERION",'v0.9')

with open(REGION_INFO,'r') as region_fp:
   data = json.loads(region_fp.read())
   for region in data['regions'].keys():
      if region in REGION_LIST:
         # determine if the destination directory already exists
         target_dir = os.path.join(MG_HARD_DISK,'output/stage4',
                  os.path.basename(data['regions'][region]['url']))
         target_dir = target_dir[:target_dir.rfind('.zip')]
         if os.path.isdir(target_dir): continue
         # copy the resources for displaying regional maps
         dest = os.path.join(MG_HARD_DISK,'output/stage4/fromscratch')
         shutil.copytree(os.path.join(MG_HARD_DISK,
               'output/stage3/fromscratch'),dest)
         filename = os.path.join(target_dir,MAP_DATE + '_' + region + '_' + MAP_VERSION + '.mbtiles')
         os.rename(dest,target_dir)
         src_region = os.path.join(MG_HARD_DISK,'output',region + '.mbtiles')
         shutil.copy(src_region,filename)
         os.symlink('./' + os.path.basename(filename),os.path.dirname(filename) + "/base.mbtiles")
