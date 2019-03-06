#!/usr/bin/env python
# create spec for bounding boxes used in IIAB vector map subsets

from geojson import Feature, Point, FeatureCollection, Polygon
import geojson
import json


def main():
   features = []
   with open('regions.json','r') as regions:
      reg_str = regions.read()
      info = json.loads(reg_str)
   #print(json.dumps(info,indent=2))
   for root in info.keys():
      for region in info[root]:
        west = float(info[root][region]['west'])
        south = float(info[root][region]['south'])
        east = float(info[root][region]['east'])
        north = float(info[root][region]['north'])
        poly = Polygon([[[west,south],[east,south],[east,north],[west,north],[west,south]]])
        features.append(Feature(geometry=poly,properties={"name":region}))

      collection = FeatureCollection(features)
      print(geojson.dumps(collection, indent=2))

if __name__ == '__main__':
   main()
