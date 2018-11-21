# docker 

This repo contains docker files to build docker images for tracy science code

## ubuntu16.04
docker files based on ubuntu 16.04

### build & run 
1. Run the "build_docker_images.sh" script to build all the images, "tracy_science" is the super image which contains all the other images
2. Use "docker run -it --rm tracy_science /bin/bash" to start a super container
3. Switch to user "tracy" by typing in "su - tracy", all the projects are under /home/tracy
4. "build_docker_images.sh" script has an option "--devmode", when this option is specified, it will keep the source code of all the projects;
Otherwise, it will delete source code and other unwanted files as much as possible to reduce the size of the docker images. 
