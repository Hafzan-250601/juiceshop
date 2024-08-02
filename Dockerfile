FROM node:20-buster as installer
COPY . /juice-shop
WORKDIR /juice-shop
RUN npm i -g typescript ts-node
RUN npm install --omit=dev --unsafe-perm

# Install the latest Contrast agent and the cli rewriter
RUN npm install @contrast/agent@latest
RUN npm install --save-dev @contrast/cli

# Environment variables for the Contrast agent
ENV CONTRAST__AGENT__LOGGER__STDOUT=true
ENV CONTRAST__AGENT__LOGGER__PATH=/dev/null

# Take note that the following is optional and the var name has changed from what was used by the v4 agent
ENV CONTRAST__AGENT__NODE__REWRITE__CACHE__PATH="/juice-shop/rewrite_cache"

# Assumes this project is rewriting for Assess only 
ENV CONTRAST__ASSESS__ENABLE=true

# If no environment setting is specified the rewiter rewrites Protect only.  See the documentation to other settings.
RUN npx -p @contrast/cli rewrite build/app.js

RUN npm dedupe --omit=dev
RUN rm -rf frontend/node_modules
RUN rm -rf frontend/.angular
RUN rm -rf frontend/src/assets
RUN mkdir logs
RUN chown -R 65532 logs
RUN chgrp -R 0 ftp/ frontend/dist/ logs/ data/ i18n/
RUN chmod -R g=u ftp/ frontend/dist/ logs/ data/ i18n/
RUN rm data/chatbot/botDefaultTrainingData.json || true
RUN rm ftp/legal.md || true
RUN rm i18n/*.json || true

ARG CYCLONEDX_NPM_VERSION=latest
RUN npm install -g @cyclonedx/cyclonedx-npm@$CYCLONEDX_NPM_VERSION
RUN npm run sbom

# workaround for libxmljs startup error
FROM node:20-buster as libxmljs-builder
WORKDIR /juice-shop
RUN apt-get update && apt-get install -y build-essential python3
COPY --from=installer /juice-shop/node_modules ./node_modules
RUN rm -rf node_modules/libxmljs/build && \
  cd node_modules/libxmljs && \
  npm run build

FROM node:20-buster-slim
ARG BUILD_DATE
ARG VCS_REF

WORKDIR /juice-shop
COPY --from=installer /juice-shop .
COPY --from=libxmljs-builder /juice-shop/node_modules/libxmljs ./node_modules/libxmljs
EXPOSE 3000

# Contrast logs will be written to the container
# This sets the rewrite cache path to match what was specified in previously created image.  Also take note that the following is optional (either do not set on both places or set in both places) and the var name has changed from what is used by the v4.x agent
ENV CONTRAST__AGENT__NODE__REWRITE__CACHE__PATH="/juice-shop/rewrite_cache"

# The following explicitly turns on Assess mode
ENV CONTRAST__ASSESS__ENABLE=true

# The start command has been modified to load and run the agent 
CMD ["node", "--import",  "@contrast/agent", "build/app.js"]
