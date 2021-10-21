#!/bin/bash

# Quick hack for getting proper paths of wrong refs
# Author: herbert.knapp@qenta.com

INVALID_REFS=$(
  for L in "$(grep --include=\*.html -r build/site -e 'class="page unresolved"')"; do
    ADOC=$(echo "${L}" | cut -d : -f1 | sed -e 's,build/site/online-guides/main/,content/online-guides/modules/ROOT/pages/,' | sed -e 's,/index.html,.adoc,')
    REF=$(echo "${L}" | sed 's,.* href="#\(.*\.adoc\).*,\1,')
    grep -n "${REF}" ${ADOC} | sed 's,^content/,,'
  done | sort | uniq
)
N_REFS=$(echo "${INVALID_REFS}" | wc -l | xargs)
N_FILES=$(echo "${INVALID_REFS}" | cut -d ':' -f1 | uniq | wc -l | xargs)

[[ ${N_REFS} -lt 1 ]] && exit 0

echo "::warning::${N_FILES} pages contain invalid references. Please check build log for details!"
echo "::group::Click to show files"
echo "${INVALID_REFS}"
echo "::endgroup::"

exit 1
