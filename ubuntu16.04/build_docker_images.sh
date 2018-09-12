#! /bin/bash

docker image build -t ubuntu4tracy:16.04 -f ubuntu16.dockerfile .

docker image build -t wannier4tracy -f wannier.dockerfile .

docker image build -t dft_qe4tracy -f dft_qe.dockerfile .

docker image build -t soap4tracy -f soap.dockerfile .

docker image build -t pymatnest4tracy -f pymatnest.dockerfile .

docker image build --squash -t tracy_science:squash -f tracy_science.dockerfile .

docker run -d --name=tracy_science_squash tracy_science:squash

docker export tracy_science_squash | docker import - tracy_science

docker stop tracy_science_squash

docker rm tracy_science_squash

docker rmi tracy_science:squash

# Use this command to start the docker container
#docker run -it --rm --user=tracy tracy_science /bin/bash
