#!/bin/bash

# Token with rights to main repo must be passed from CI 
#
#        env:
#          BOT_USER: ${{ secrets.BOT_USER }}
#          BOT_EMAIL: ${{ secrets.BOT_EMAIL }}
#          BOT_TOKEN: ${{ secrets.BOT_TOKEN }}

CFG_BOT_USER=${BOT_USER}
CFG_BOT_EMAIL=${BOT_EMAIL}
CFG_BOT_TOKEN=${BOT_TOKEN}

CFG_GH_PAGES_REPO_URI="https://${CFG_BOT_TOKEN}@github.com/qenta-cee/qenta-docs-main.git"
CFG_CONTENT_REPO_URI="https://${CFG_BOT_TOKEN}@github.com/qenta-cee/qenta-docs-content.git"
CFG_REPO_BRANCH='gh-pages'

CFG_GH_PAGES_WORKSPACE="$(mktemp -d)"
CFG_CONTENT_WORKSPACE="$(mktemp -d)"

function get_raw_renames() {
  (
    cd ${CFG_CONTENT_WORKSPACE}
    git clone ${CFG_CONTENT_REPO_URI} .
    git log --name-status | grep ^R | grep '.adoc$' | grep -v '/partials/' | sed 's/[ \t]\+/;/g'
  )
}

function get_html_path() {
  sed 's,.\+/modules/ROOT/pages/\(.*\).adoc,\1/index.html,' <<< ${1}
}

function create_meta_refresh() {
  echo -n '<meta http-equiv="refresh" content="0;URL='
  echo -n "'"
  echo -n /${1}
  echo -n "'"
  echo '" />'
}

function write_to_html {
  local META_TAG=${1}
  local FILE_PATH=${CFG_GH_PAGES_WORKSPACE}/${2}
  local DIR_TREE=$(dirname ${FILE_PATH})
  mkdir -p ${DIR_TREE}
  echo "${META_TAG}" > "${FILE_PATH}"
}

function create_workspace() {
  (
    mkdir -p ${CFG_GH_PAGES_WORKSPACE}
    cd ${CFG_GH_PAGES_WORKSPACE}
    git clone --branch ${CFG_REPO_BRANCH} ${CFG_GH_PAGES_REPO_URI} .
  )
}

function create_redirect_files() {
  NEW_REDIRECTS=0
  for line in $(get_raw_renames); do
    arr_git_output=(${line//;/ })

    OLD_PATH_ADOC=${arr_git_output[1]}
    OLD_PATH_HTML=$(get_html_path ${OLD_PATH_ADOC})

    NEW_PATH_ADOC=${arr_git_output[2]}
    NEW_PATH_HTML=$(get_html_path ${NEW_PATH_ADOC})

    META_TAG=$(create_meta_refresh ${NEW_PATH_HTML/\/index.html//})

    write_to_html "${META_TAG}" "${OLD_PATH_HTML}"
    
    NEW_REDIRECTS=$(( NEW_REDIRECTS + 1 ))
  done

  return ${NEW_REDIRECTS}
}

function publish() {
  (
    cd ${CFG_GH_PAGES_WORKSPACE}
    git config user.name "${CFG_BOT_USER}"
    git config user.email "${CFG_BOT_EMAIL}"
    git add . && \
    git commit -m "CI: add redirects" && \
    git push
  )
}

create_workspace
create_redirect_files
NUM_REDIRECTS=$?

if [[ ${NUM_REDIRECTS} > 0 ]]; then
  publish
else
  echo "No renames found."
fi
