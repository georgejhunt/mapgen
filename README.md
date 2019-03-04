### Generate OSM Regions to Zoomm 14 ###
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
2. Script written to fine tune the process for just one small region.
3. Then the process can be increased to create first release of the 2017 data for all of the regions.
##### Eventually #####
1. Pipeline should use the regional subset of more recent OSM pbf data as its source.
2. So far, I have only found a cookbook that uses docker to create a regional subset of vector tiles. It deletes the postgress database, and starts from scratch every time it is run. 
3. We need to realize that we are in the business of generating vector subsets over the long term, and define a path that is efficient in meeting that objective.
