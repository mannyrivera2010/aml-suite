#!/bin/sh

# SLOCcounts are evil, but file/SLOC counts can be semi-useful to get a rough
#   idea of complexity

wget http://sourceforge.net/p/cloc/code/HEAD/tree/trunk/cloc?format=raw -O cloc
chmod +x cloc

git clone https://github.com/ozone-development/hud-ui.git
git clone https://github.com/ozone-development/center-ui.git
git clone https://github.com/ozone-development/ozp-rest.git
git clone https://github.com/ozone-development/ozp-iwc.git
git clone https://github.com/ozone-development/ozp-webtop.git

echo "******************************\n hud-ui SLOCcount\n******************************"
./cloc hud-ui/
echo "******************************\n center-ui SLOCcount\n******************************"
./cloc center-ui
echo "******************************\n ozp-rest SLOCcount\n******************************"
./cloc ozp-rest --exclude-dir=plugins,wrapper,web-app
echo "******************************\n ozp-iwc SLOCcount\n******************************"
./cloc ozp-iwc --exclude-dir=data-schemas,dist,demo,test
echo "******************************\n ozp-webtop SLOCcount\n******************************"
./cloc ozp-webtop --exclude-dir=tools --exclude-ext=spec.js