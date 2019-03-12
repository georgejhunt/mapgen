### Generate OSM Regions to Zoom 14 ###
##### Objectives #####
1. Create pipeline, and script for upload of generated modules to Internet Archive.
2. Create mechanism for selection, and download, of these regional packages in IIAB administrative console.
3. Pull iiab-factory files into this repo, so that it may stand alone, and be moved to a faster, or different machine, easily.
4. Whether the critical files are copied back to iiab-factory, remains to be seen.
5. Scripts written to accomodate faster SSD hard disks, and larger spinning disks.
6. Avoid inclusion of intermediate files, or larger files, in this repo.
7. But include automation of the installation process for tools that are part of the data path.
##### First Steps #####
1. I've had so much trouble with module loading in js, and dealing with ES5 vs ES6 compatability, I want to get new instances of babel an webpack working. This will let me know that I can do it again next time. (babel and webpack config require initial config that I had to learn by trial and error).
1. The regional subsets of OSM vector tiles will initially be based upon the 2017 planet vector file (55 GB).
2. Scripts written to fine tune the process for just one small region.
   1. After the regional subsets are generated (stage 2) on ssd disk to ./mapgen/output/*.mbtiles, they are moved to hard disk for the rest of the process (took about 5 hours--much longer on rotating disk).
   2. Update the regions.json with perma_ref and size information into ./mapgen/output/stage2/.
   3. Stage 3 pulls down and assembles the resources required by the application.  Then it does a bulk copy of the application and merges in the regional mbtile.
   4. Stage 4 zips up the package, and uploads it to our content delivery system (probably archive.org).
3. Then the process can be increased to create first release of the 2017 data for all of the regions.
#### Time Out to Consolidate and Simplify (3/10/2019) ####
1. I started out wanting  to separate code and disk space intensive operaations (created MG_SSD, and MG_HARD_DISK). But as function, and the number of scripts has grown, I cannot remember were each step is located.
2. I am deciding to have a single variable (PREFIX) which is the location for all operations. After the process is complete, the whole tree can be transferred to hard disk for archival purposes (seems to run 4x faster on SSD).
3. Then there is the question, where does this all belong? Long run, probably in IIAB-FACTORY. But factory is already so big, and vector maps are down in the tree pretty far.  I use git a lot to move testing copies of what I'm working on to different places, machines, environments. (And sometimes I forget which machine, tree, environment has the latest/best). So starting to minimize complexity is becomming critical.
#### Record Current State ####
A. Admin Console resources
   1. "regions.json" is the ultimate source for everything.
   2. /roles/console/js/map_functions.js works in conjunction with 3 downloaded d.iiab.io files (a bundle of openlayer js functions -- map.js, countries.geojson, and bboxes.geojson).
   
B. Regional Vector tile subsets of the Openmaptiles World 
   1. Mapgen repository is the work environment tree.
   2. Script 1setup.sh installs webpack, rollup, tilelive (does the mbtiles subset operation), openmaptiles/extracts(which reads the csv file iiab.csv, and calls tilelive-copy).
   3. Larger context: "setenv.template" gets copyed to setenv, and must be sourced ("source setenv") to make the configureation for both the bash scripts, and the python scriipts.
   4. A sequence of bash scripts creates the regional packages that may be downloaded vi the Admin Console
       1. 1setup.sh -- Creates the environment for a sequence of operations
       2. 2extract.sh -- Creates world mbtile starting point to intermediate zoom level, and then adds vector tiles to z14 for a region specified in regions.json.
       3. 3assemble.sh -- combines all of the resources required for a regional package
       4. 4package.sh -- zips up the assembled resources, and moves them to publishing location
   
##### Eventually #####
1. Pipeline should use the regional subset of more recent OSM pbf data as its source.
2. So far, I have only found a cookbook that uses docker to create a regional subset of vector tiles. It deletes the postgress database, and starts from scratch every time it is run. 
3. We need to realize that we are in the business of generating vector subsets over the long term, and define a path that is efficient in meeting that objective.
