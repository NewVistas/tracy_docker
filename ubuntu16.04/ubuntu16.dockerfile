#
# ubuntu 16.04 dressed up for scientific computing
#
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update; apt -yq upgrade; \
    apt install -yq \
      autoconf  \
      ca-certificates  \
      make  \
      cmake \
      g++ \
      gawk \
      gfortran-5  \
      git \
      gnuplot \
      libgsl-dev \
      libreadline-dev \
      libnetcdf-dev \
      libblacs-mpi-dev  \
      libblacs-openmpi1  \
      libgfortran-5-dev  \
      libmatheval1 \
      libmatheval-dev \
      libopenblas-base  \
      libopenblas-dev  \
      liblapack-dev \
      libopenmpi-dev  \
      libxext-dev \
      libfftw3-3  \
      libfftw3-bin  \
      libfftw3-dev  \
      libfftw3-doc  \
      libfftw3-double3   \
      net-tools  \
      openssh-server  \
      python3 \
      python3-pip \
      python3-dev \
      python3-setuptools \
      python3-numpy \
      python3-numpydoc \
      python3-scipy \
      sudo \
      nano \
      vim \
      wget  \
      xxdiff \
      zlib1g zlib1g-dev \
      #{{ addtional packages needed for SOAP
      software-properties-common \
      libboost-all-dev \
      python3-sklearn \
      python3-psutil \
      python3-h5py \
      python3-sh \
      #}}
      xdg-utils \
      --no-install-recommends \
    && apt autoremove   -y \
    && rm -rf /var/apt/lists/* \
    && ssh-keygen -A

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install mpi4py \
    && python3 -m pip install ase \
    && python3 -m pip install --upgrade mpi4py \
    && python3 -m pip install --upgrade ase \
    && python3 -m pip install boost \
    && python3 -m pip install lxml

# we create the user 'tracy' and add it to the list of sudoers
RUN adduser -q --disabled-password --gecos tracy tracy          \
    && printf "\ntracy ALL=(ALL:ALL) NOPASSWD:ALL\n" >>/etc/sudoers.d/tracy \
    && (echo "tracy:tracy" | chpasswd) 

ENV USER_NAME="tracy"
ENV HOME_DIR="/home/tracy" 

CMD ["sudo","sshd","-D"]
