#!/bin/bash
docker build -t custombuntu:latest .
docker run -p "5901:5901" --rm  --name custombuntu --mount src=$(pwd)/shared_folder,target=/home/nonroot/shared_folder,type=bind -it custombuntu:latest