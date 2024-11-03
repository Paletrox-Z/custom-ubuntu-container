#!/bin/bash
docker build -t custombuntu:latest .
docker run -p "5901:5901" --rm --name custombuntu -it custombuntu:latest