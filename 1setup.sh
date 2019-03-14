#!/bin/bash -x
# Set up babel, webpack, tilelive-copy, extract programs, mk diretories, config
# The setenv.template is a model, -- setenv is not overriden, must handcode it

# first check that the environment has been set
MG=${MG_SSD}
if [ "$MG" == "" ];then
   echo "Have you set the environment variables via 'source ./setenv'"
   exit 1
fi

# set up the output/input directors for pipeline
# all steps including generation of extracts done on SSD
mkdir -p $MG_SSD/output/stage1
mkdir -p $MG_SSD/output/stage2
# for stage3 and following, use hard disk
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
  mkdir -p ../src ../build
  sed -i 's/.*test.*/    "build": "babel --presets es2015 ..\/src ..\/build"/' $MG_SSD/babel/package.json
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
  npm install --save-dev webpack babel-loader webpack-dev-server webpack-cli
  npm install --save-dev babel-preset-env copy-webpack-plugin
  npm install --save-dev html-webpack-plugin
  npm install --save-dev ol-mapbox-style ol babel/core
# add the following to package.json
  sed -i 's/.*test.*/"babel": "babel --presets es2015 ..\/src\/main.js -o ..\/build\/main.bundle.js",\
     "start": "webpack-dev-server --mode=development",\
     "build": "webpack --mode=production"/' $MG_SSD/pack/package.json

    cat <<'EOF' >$MG_SSD/pack/webpack.config.js
const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');
const HtmlPlugin = require('html-webpack-plugin');

module.exports = {
  entry: '../src/main.js',
  output: {
    path: path.resolve(__dirname, 'build'),
    filename: 'main.js'
  },
  devtool: 'source-map',
  devServer: {
    host: '0.0.0.0',
    port: 3001,
    clientLogLevel: 'none',
    //stats: 'verbose'
    stats: 'errors-only'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  plugins: [
    new CopyPlugin([{from: '../src/assets', to: 'assets'}]),
    new HtmlPlugin({
      template: '../src/index.html'
    })
  ]
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
$MG_SSD/mkjson.py > $MG_SSD/build/bboxes.geojson

