# Start from an existing app image
FROM bkimminich/juice-shop:v12.7.0

WORKDIR /juice-shop

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

# Contrast logs will be written to the container
# This sets the rewrite cache path to match what was specified in previously created image.  Also take note that the following is optional (either do not set on both places or set in both places) and the var name has changed from what is used by the v4.x agent
ENV CONTRAST__AGENT__NODE__REWRITE__CACHE__PATH="/juice-shop/rewrite_cache"

# The following explicitly turns on Assess mode
ENV CONTRAST__ASSESS__ENABLE=true

# The start command has been modified to load and run the agent 
CMD ["node", "--import",  "@contrast/agent", "build/app.js"]
