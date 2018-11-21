#
# ubuntu 16.04 dressed up for scientific computing
#
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -yq \
      autoconf  \
      ca-certificates  \
      cmake \
      g++ \
      gawk \
      gdb \
      gfortran-5  \
      git \
      gnuplot \
      libboost-all-dev \
      libgsl-dev \
      libreadline-dev \
      libblacs-mpi-dev  \
      libblacs-openmpi1  \
      libgfortran-5-dev  \
      libmatheval1 \
      libmatheval-dev \
      libopenblas-base  \
      libopenblas-dev  \
      libopenmpi-dev  \
      libnetcdf-dev \
      liblapack-dev \
      libfftw3-3  \
      libfftw3-bin  \
      libfftw3-dev  \
      libfftw3-doc  \
      libfftw3-double3   \
      libxext-dev \
      make  \
      nano \
      net-tools  \
      openssh-server  \
      python3-numpy \
      python3-numpydoc \
      python3-scipy \
      python \
      python-dev \
      python-h5py \
      python-pip \
      python-setuptools \
      python-sh \
      python-sklearn \
      python-psutil \
      python-tk \
      software-properties-common \
      sudo \
      vim \
      wget  \
      xdg-utils \
      xxdiff \
      zlib1g zlib1g-dev \
      --no-install-recommends \
    && apt autoremove   -y \
    && rm -rf /var/apt/lists/* \
    && ssh-keygen -A

RUN python -m pip install --upgrade pip \
    && python -m pip install ase \
    && python -m pip install boost \
    && python -m pip install lxml \
    && python -m pip install mpi4py \
    && python -m pip install --upgrade ase \
    && python -m pip install --upgrade mpi4py 

# we create the user 'tracy' and add it to the list of sudoers
RUN adduser -q --disabled-password --gecos tracy tracy          \
    && printf "\ntracy ALL=(ALL:ALL) NOPASSWD:ALL\n" >>/etc/sudoers.d/tracy \
    && (echo "tracy:tracy" | chpasswd) 

ENV USER_NAME="tracy"
ENV HOME_DIR="/home/tracy" 

CMD ["sudo","sshd","-D"]
