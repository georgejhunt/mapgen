#!/usr/bin/env  python
# Output the regions in regions.json

import os,sys
import json
import sqlite3

MG_SSD = os.environ.get("MG_SSD",'/root/mapgen')
REGION_INFO = os.path.join(MG_SSD,'regions.json')

MG_HARD_DISK = os.environ.get("MG_HARD_DISK",'/hd/mapgen')

outstr = ''
region_list = []
with open(REGION_INFO,'r') as region_fp:
   data = json.loads(region_fp.read())
   for region in data['regions'].keys():
      conn = sqlite3.connect(os.path.join(MG_HARD_DISK,
			'output',region+'.mbtiles'))
      c = conn.cursor()
      sql = 'select value from metadata where name = "filesize"'
      try:
         c.execute(sql)
      except:
         print("ERROR")
      row = c.fetchone()
	   #print(row[0])
      if row:
         data['regions'][region]['size'] = row[0]
      data['regions'][region]['perma_ref'] = 'en-osm-omt_' + region
      data['regions'][region]['url'] = 'http://192.168.123.5/content/maps/'\
		 + os.environ.get("MAP_DATE") + '_' + region + '_'\
		 + os.environ.get("MAP_VERSION",'v0.9') + '.zip'
   outstr = json.dumps(data,indent=2) 
   print(outstr)

with open(REGION_INFO,'w') as region_fp:
   region_fp.write(outstr)
