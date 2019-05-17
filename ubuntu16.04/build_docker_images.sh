#! /bin/bash
CUR_DIR=$(pwd)
PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $PARENT_DIR

DEV_MODE=false
while [[ $# -gt 0 ]] && [[ ."$1" = .--* ]] ;
do
    opt="$1";
    shift;              #expose next argument
    case "$opt" in
        "--devmode" )
           DEV_MODE=true;;
        *) echo >&2 "Invalid option: $@"; exit 1;;
   esac
done

# build ubuntu base image
docker image build -t ubuntu4tracy:16.04 -f ubuntu16.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building ubuntu4tracy"
  exit 1
fi

# build dft_qe
docker image build -t dft_qe4tracy:squash -f dft_qe.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building dft_qe4tracy:squash"
  exit 1
fi

docker run -d --name=dft_qe4tracy_squash dft_qe4tracy:squash
if [ $? -ne 0 ]; then
  echo "ERROR on running dft_qe4tracy_squash"
  exit 1
fi

docker export dft_qe4tracy_squash | docker import - dft_qe4tracy
if [ $? -ne 0 ]; then
  echo "ERROR on exporting/importing dft_qe4tracy_squash"
  exit 1
fi

docker stop dft_qe4tracy_squash
if [ $? -ne 0 ]; then
  echo "ERROR on stopping dft_qe4tracy_squash"
  exit 1
fi

docker rm dft_qe4tracy_squash
if [ $? -ne 0 ]; then
  echo "ERROR on removing container dft_qe4tracy_squash"
  exit 1
fi

docker rmi dft_qe4tracy:squash
if [ $? -ne 0 ]; then
  echo "ERROR on removing image dft_qe4tracy:squash"
  exit 1
fi

# build pslibrary image, this will be used by matdb. It's base on dft_qe4tracy
docker image build -t pslibrary4tracy -f pslibrary.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building image pslibrary4tracy"
  exit 1
fi

# Temporarily disable the rest projects for M1
# Note: We upgraded python to 3.5 from the ubuntu4tracy image,
#   but quip may not support python3 yet. Need to figure that out
#   when we building quip/lammps/pymatnest
exit 0

# build wannier
if [ ${DEV_MODE} == true ] ; then
  docker image build -t wannier4tracy -f wannier.dockerfile . --build-arg DEV_MODE="YES"
else
  docker image build -t wannier4tracy -f wannier.dockerfile . --build-arg DEV_MODE="NO"
fi
if [ $? -ne 0 ]; then
  echo "ERROR on building wannier4tracy"
  exit 1
fi

# build soapxx
docker image build -t soap4tracy -f soap.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building soap4tracy"
  exit 1
fi

# build quip (serial version)
docker image build -t quip4tracy -f quip.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building quip4tracy"
  exit 1
fi

# build lammps
docker image build -t lammps4tracy -f lammps.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building lammps4tracy"
  exit 1
fi

#build pymatnest
docker image build -t pymatnest4tracy -f pymatnest.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building pymatnest4tracy"
  exit 1
fi

# build super image
docker image build --squash -t tracy_science:squash -f tracy_science.dockerfile .
if [ $? -ne 0 ]; then
  echo "ERROR on building tracy_science:squash"
  exit 1
fi

docker run -d --name=tracy_science_squash tracy_science:squash
if [ $? -ne 0 ]; then
  echo "ERROR on running tracy_science_squash"
  exit 1
fi

docker export tracy_science_squash | docker import - tracy_science
if [ $? -ne 0 ]; then
  echo "ERROR on exporting/importing tracy_science"
  exit 1
fi

docker stop tracy_science_squash
if [ $? -ne 0 ]; then
  echo "ERROR on stopping tracy_science_squash"
  exit 1
fi

docker rm tracy_science_squash
if [ $? -ne 0 ]; then
  echo "ERROR on removing container tracy_science_squash"
  exit 1
fi

docker rmi tracy_science:squash
if [ $? -ne 0 ]; then
  echo "ERROR on removing image tracy_science:squash"
  exit 1
fi

cd $CUR_DIR

# Use this command to start the docker container
#docker run -it --rm --user=tracy tracy_science /bin/bash
