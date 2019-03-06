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
##### Eventually #####
1. Pipeline should use the regional subset of more recent OSM pbf data as its source.
2. So far, I have only found a cookbook that uses docker to create a regional subset of vector tiles. It deletes the postgress database, and starts from scratch every time it is run. 
3. We need to realize that we are in the business of generating vector subsets over the long term, and define a path that is efficient in meeting that objective.
