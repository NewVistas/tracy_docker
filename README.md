# docker 

This repo contains docker files to build docker images for tracy science code

## ubuntu16.04
docker files based on ubuntu 16.04

### build & run 
Run the "build_docker_images.sh" script to build all the images 
"tracy_science" is the super image which contains all the other images
Use "docker run -it --rm tracy_science /bin/bash" to start a super container
Switch to user "tracy" by typing in "su - tracy", all the projects are under /home/tracy
 
