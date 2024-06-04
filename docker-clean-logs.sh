#!/bin/bash

# Stop all running containers
docker stop $(docker ps -q)

# Clear logs for each container
for container_id in $(docker ps -a -q)
do
  log_file=$(docker inspect --format='{{.LogPath}}' "$container_id")
  echo "" > $log_file
done

# Start all containers again
docker start $(docker ps -a -q)
