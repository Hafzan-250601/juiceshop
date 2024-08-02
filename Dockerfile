# Start from an existing app image
FROM bkimminich/juice-shop

WORKDIR /juice-shop

#Install python
RUN apt-get install python3 python3-pip

# Add in the Contrast agent
RUN npm install --production @contrast/agent

# Change the startup command to preload Contrast agent
CMD ["node", "-r", "@contrast/agent", "build/app"]
