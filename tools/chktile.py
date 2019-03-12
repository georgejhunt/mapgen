#!/usr/bin/env python 
# create a tool for diagnosing tile subset problems
import os,sys
import json
import math

MG_SSD = os.environ.get("MG_SSD",'/root/mapgen')
REGION_INFO = os.path.join(MG_SSD,'regions.json')

MG_HARD_DISK = os.environ.get("MG_HARD_DISK",'/hd/mapgen')

outstr = ''
region_list = []

###########  Functions  ################
def num2deg(xtile, ytile, zoom):
  n = 2.0 ** zoom
  lon_deg = xtile / n * 360.0 - 180.0
  lat_rad = math.atan(math.sinh(math.pi * (1 - 2 * ytile / n)))
  lat_deg = math.degrees(lat_rad)
  return (lat_deg, lon_deg)

def deg2num(lat_deg, lon_deg, zoom):
  lat_rad = math.radians(lat_deg)
  n = 2.0 ** zoom
  xtile = int((lon_deg + 180.0) / 360.0 * n)
  ytile = int((1.0 - math.log(math.tan(lat_rad) + (1 / math.cos(lat_rad))) / math.pi) / 2.0 * n)
  return (xtile, ytile)

def init():
   with open(REGION_INFO,'r') as region_fp:
      data = json.loads(region_fp.read())
      for extract in data['regions'].keys():

if __name__ == "__main__":
   init()
   main()
   response = raw_input("\ninput z x y:\n")
   vals = response.split(' ')
   print(deg2num(float(vals[2]),float(vals[1]),float(vals[0])))
