# Tracy Docker

This repo contains docker files to build docker images for Tracy Science code.
docker files based on ubuntu 16.04.

The build process is broken down into several docker images, then they are stacked on top of each other.

Ubuntu 16.04 was chosen for the compatibility with the libraries used in the project. Future effort should be undertaken to transition to the most current (and compatible) LTS release of ubuntu.

### Current State

The build process includes the following external projects.

- [Quantum Espresso](https://github.com/QEF/q-e/)
- [pslibrary](https://github.com/dalcorso/pslibrary)

Excluded in the build:
- [lammps](https://github.com/lammps/lammps)
- [pymatnest](https://github.com/libAtoms/pymatnest)
- [quip](https://github.com/libAtoms/QUIP)
- [wannier](http://www.wannier.org/news/wannier90/)

The excluded projects have docker files in the build script that are currently being skipped. The `build_docker_images.sh` exits early, but includes instructions to incorporate them.

### Build Base "Super" Image

Using a shell of your choice go into the `ubuntu16.04` directory and run the `build_docker_images.sh` script to build all the images, `ubuntu4tracy` is the super image which contains all the other images.
You can verify the image is registered by the correct name properly by running `docker images` then looking for `ubuntu4tracy`.

### Run

Use `docker run -it --rm tracy_science /bin/bash` to start a super container.

Notes:
- To run as the `tracy` user instead, use `docker run -it --rm --user tracy tracy_science /bin/bash`.
- `build_docker_images.sh` script has an option `--devmode`, when this option is specified, it will keep the source code of all the projects.
    - Otherwise, it will delete source code and other unwanted files as much as possible to reduce the size of the docker images.
- If any of the shell scripts don't already have executable permissions, give it to them via `chmod +x <filename>`.

### Build MLIP Image

As of writing this document, the public version of [MLIP](http://gitlab.skoltech.ru/shapeev/mlip) is on commit [`52f0305e`](http://gitlab.skoltech.ru/shapeev/mlip/commit/52f0305ef9bf1d571fb1f1f366bf306a072c1f91) which was authored Nov 8, 2017. The MLIP version used with this project is newer, and was given privately. You must obtain your own version via you own means. Asking the author, Alexander Shapeev is our recommended approach.

Once you obtain your up to date version of MLIP, we can start to build the image related to it.

Place the relevant files found in `build_mlip` at the top level of the MLIP project.

Folder structure of tracy docker project with a focus on `build_mlip`.
```
tracy_docker
├── ... other docker files ...
└── build_mlip
    ├── build_mlip_docker_image.sh
    └── mlip4tracy.dockerfile
```

Folder structure of your copy of MLIP after placing copies of the relevant files.
```
mlip
├── ... other source files ...
├── build_mlip_docker_image.sh
└── mlip4tracy.dockerfile
```

Then to build the image just run the `build_mlip_docker_image.sh` script. Note that this image is built off the `ubuntu4tracy` image.

### Run MLIP

This is done the same as the previous **Run** section, but instead using the docker image name of `mlip4tracy`.

### Windows 10 Caveats

Firstly, we only tested on Windows 10. No other windows platform.

We use git BASH to run the bash scripts. Git BASH is included with [git for Windows](https://gitforwindows.org/). Which is useful, since you will need git anyways to clone the projects.

Docker for windows (without requiring an account) can be downloaded [here](https://docs.docker.com/docker-for-windows/release-notes/).

Issues:
- using `docker run -it --rm matdb /bin/bash` doesn't work properly. Two things must be done:
        - prefix the command with `winpty`
        - the command must **not** be a path
    - Thus the command that should be entered instead `winpty docker run -it --run matdb bash`
- Running matdb locally within docker has issues with processes freezing.
    - We have not fixed this issue. Users may proceed to do so if they wish.
    - Running windows is still fine if you want to build the images then upload to AWS.
        - This is the recommended approach when using windows.
        - Deployment to a remote AWS instance is covered in the Tracy Matdb readme.
