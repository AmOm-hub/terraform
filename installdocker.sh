#!/bin/bash

# Update the package index and install required packages
sudo yum update -y
sudo amazon-linux-extras install docker

# Start Docker service and enable it to start at boot time
sudo service docker start

# Run a container on port=80:3000 name=amit it wile remove it self when it will stop and will run in detach mode
sudo docker run -d --name amit --rm -p 80:3000 adongy/hostname-docker
