@echo off
docker build -t custombuntu:latest .
docker run -p "5901:5901" --name custombuntu -it custombuntu:latest
docker rm custombuntu