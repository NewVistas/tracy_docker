#! /bin/bash

# build ubuntu base image
docker image build -t ubuntu4tracy:16.04 -f ubuntu16.dockerfile .

# build wannier
docker image build -t wannier4tracy -f wannier.dockerfile .

# build dft_qe
docker image build -t dft_qe4tracy:squash -f dft_qe.dockerfile .
docker run -d --name=dft_qe4tracy_squash dft_qe4tracy:squash
docker export dft_qe4tracy_squash | docker import - dft_qe4tracy
docker stop dft_qe4tracy_squash
docker rm dft_qe4tracy_squash
#docker rmi dft_qe4tracy:squash

# build soapxx
docker image build -t soap4tracy -f soap.dockerfile .

# build quip (serial version)
docker image build -t quip4tracy -f quip.dockerfile .

# build lammps
docker image build -t lammps4tracy -f lammps.dockerfile .

#build pymatnest
docker image build -t pymatnest4tracy -f pymatnest.dockerfile .

# build super image
docker image build --squash -t tracy_science:squash -f tracy_science.dockerfile .
docker run -d --name=tracy_science_squash tracy_science:squash
docker export tracy_science_squash | docker import - tracy_science
docker stop tracy_science_squash
docker rm tracy_science_squash
docker rmi tracy_science:squash

# build pslibrary image, this will be used by matdb. It's base on dft_qe4tracy
docker image build -t pslibrary4tracy -f pslibrary.dockerfile .

# Use this command to start the docker container
#docker run -it --rm --user=tracy tracy_science /bin/bash
