FROM antora/antora:3.0.0-alpha.1
ENV DOCSEARCH_ENABLED=true
ENV DOCSEARCH_ENGINE=lunr
ENV NODE_PATH="/usr/local/lib/node_modules"
ENV DOCSEARCH_INDEX_VERSION=latest
RUN yarn global add http-server onchange
RUN yarn global add antora-site-generator-lunr
WORKDIR /srv/docs
