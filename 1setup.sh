#!/bin/bash -x
# Set up babel and webpack

# first grab the local environment for mapgen
source mapgen_env

which node
if [ $? -ne 0 ]; then
   echo nodejs is required as a precondition for mapgen. -- quitting
   exit 1
fi

# make sure that babel is installed and configured
#
if [ ! -d "$MG_SSD/babel/node_modules" ];then
  mkdir -p "$MG_SSD"/babel
  cd $MG_SSD/babel
  npm init -y
  npm install --save-dev babel-cli
  mkdir -p src dest
  read -p "add a line to package.json scripts tag: \"build:babel src dest\"" dummy
  npm install --save-dev babel-preset-env 
  cat <EOF>$MG_SSD/.babelrc
# https://www.sitepoint.com/babel-beginners-guide/
# http://ccoenraets.github.io/es6-tutorial/setup-babel/
{
  "presets": ["env"]
}
EOF

fi
# make sure that webpack is installed and configured
if [ ! -d "$MG_SSD/webpack/node_modules" ];then
  mkdir -p "$MG_SSD"/webpack
  cd $MG_SSD/webpack
  npm init -y
  npm install --save-dev babel-loader webpack
# add the following to package.json
#"scripts": {
#    "babel": "babel --presets es2015 js/main.js -o build/main.bundle.js",
#    "start": "http-server",
#    "webpack": "webpack"

  cat <EOF.$MG_SSD/webpack.config.js
 var path = require('path');
 var webpack = require('webpack');

 module.exports = {
     entry: './js/main.js',
     output: {
         path: path.resolve(__dirname, 'build'),
         filename: 'main.bundle.js'
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
