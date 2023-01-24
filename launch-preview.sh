#!/bin/bash

echo "Remove old pages"
rm -rf build/site

echo "Building UI"
make ui.build &>/dev/null

echo "Building Documentation"
make antora.build

make antora.run &>/dev/null &
echo -n "Staring webserver in the background"
while ! curl -s --fail http://localhost:8052/ >/dev/null; do echo -n .; sleep 3; done; echo
echo
echo "http://localhost:8052/online-guides/main/"
echo
echo "Watching for changes..."
echo  
make antora.watch >/dev/null 

