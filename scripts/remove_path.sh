#!/bin/bash

# ------------------------------------------------
# ANTORA rewrite pges for single module in / root
# ------------------------------------------------

set -e

TEMPDIR="$(mktemp -d)"
PATH_TO_REMOVE="${1:-online-guides/main}"
SED_BINARY='sed'
[[ "${OSTYPE}" == 'darwin'* ]] && SED_BINARY='gsed'
mv build/site/${PATH_TO_REMOVE}/* build/site/
rm -r build/site/${PATH_TO_REMOVE}/
find build/site/ -type f -name '*.html' > $TEMPDIR/files.list
for file in $(cat $TEMPDIR/files.list); do
  (
  ${SED_BINARY} -i 's,\(\.\./\)\+_/\.\./,/,' "$file"
  ${SED_BINARY} -i 's,\(\.\./\)\+_,/_,' "$file"
  )&
done
${SED_BINARY} -i 's,'${PATH_TO_REMOVE}/',,g' build/site/search-index.js
${SED_BINARY} -i 's,'${PATH_TO_REMOVE}/',,g' build/site/sitemap.xml
wait
