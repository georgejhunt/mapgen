#!/usr/bin/env  python
# Output the regions in regions.json

import os,sys
import json
import uuid

MG_SSD = os.environ.get("MG_SSD",'/root/mapgen')
REGION_INFO = os.path.join(MG_SSD,'regions.json')

MG_HARD_DISK = os.environ.get("MG_HARD_DISK",'/hd/mapgen')

outstr = ''
region_list = []
with open(REGION_INFO,'r') as region_fp:
   data = json.loads(region_fp.read())
   for extract in data['regions'].keys():
      outstr += extract + '\n'
      region_list.append(extract)
   #print extract
   jstr = json.dumps(region_list,indent=2)
   print(jstr)
