#!/bin/bash -x
# Set up babel and webpack

# first check that the environment has been set
MG=${MG_SSD}
if [ "$MG" == "" ];then
   echo "Have you set the environment variables via 'source ./setenv'"
   exit 1
fi

# set up the output/input directors for pipeline
mkdir -p $MG_HARD_DISK/output/stage1
mkdir -p $MG_HARD_DISK/output/stage2
mkdir -p $MG_HARD_DISK/output/stage3
mkdir -p $MG_HARD_DISK/output/stage4

which node
if [ $? -ne 0 ]; then
   echo nodejs is required as a precondition for mapgen. -- quitting
   exit 1
fi

# make sure that babel is installed and configured
#
if [ ! -d $MG_SSD/babel/node_modules ];then
  mkdir -p $MG_SSD/babel
  cd $MG_SSD/babel
  npm init -y
  npm install --save-dev babel-cli
  mkdir -p ../src ../dest
  sed -i /.*test.*/a\      "build": "babel ../src ../dest" $MG_SSD/babel/package.json
  npm install --save-dev babel-preset-env 
  cat <<EOF >$MG_SSD/.babelrc
{
  "presets": ["env"]
}
EOF
# https://www.sitepoint.com/babel-beginners-guide/
# http://ccoenraets.github.io/es6-tutorial/setup-babel/
fi

# make sure that webpack is installed and configured
if [ ! -d "$MG_SSD/pack/node_modules" ];then
  mkdir -p $MG_SSD/pack
  cd $MG_SSD/pack
  npm init -y
  npm install --save-dev webpack babel-loader
# add the following to package.json
  sed -i /.*test.*/a\      
    "babel": "babel --presets es2015 ../src/main.js -o ../dest/main.bundle.js",
    "start": "http-server",
    "webpack": "webpack" $MG_SSD/babel/package.json

    cat <<'EOF' >$MG_SSD/pack/webpack.config.js
 var path = require('path');
 var webpack = require('webpack');

 module.exports = {
     entry: '../src/map.js',
     output: {
         path: path.resolve(__dirname, '../dest/build'),
         filename: 'map.bundle.js'
     },
     module: {
         loaders: [
             {
                 test: /\.js$/,
                 loader: 'babel-loader',
                 query: {
                     presets: ['es2015']
                 }
             }
         ]
     },
     stats: {
         colors: true
     },
     devtool: 'source-map'
 };
EOF
# http://ccoenraets.github.io/es6-tutorial/setup-webpack/
fi

# the extract program is in github owned by openmmaptiles
if [ ! -d $MG_SSD/extracts ]; then
   git clone https://github.com/georgejhunt/extracts -b iiab
fi

# The extract program requires tilelive from mapbox
if [ ! -d $MG_SSD/tilelive/node_modules ]; then
   mkdir -p $MG_SSD/tilelive
   cd $MG_SSD/tilelive
   npm init -y
   npm install --save-dev @mapbox/tilelive
   npm install --save-dev @mapbox/mbtiles
fi
# create the csv file which is the spec for the regional extract stage2
$MG_SSD/mkcsv.py
$MG_SSD/mkjson.py > $MG_HARD_DISK/bboxes.geojson

