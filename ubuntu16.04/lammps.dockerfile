
FROM quip4tracy

WORKDIR "$HOME_DIR"

# All the QUIPs go here; added to path in the end.
ENV QUIP_ROOT ${HOME_DIR}/quip
ENV QUIP_ARCH linux_x86_64_gfortran

# LAMMPS compilation

# lammps should be linked with SERIAL version of QUIP
# other configurations are untested and too complicated
# for a user (mixed paralleisms).
ENV LAMMPS_PATH ${HOME_DIR}/lammps

# TODO: prune any unwanted directories in this command
RUN mkdir -p ${LAMMPS_PATH} \
    && cd ${LAMMPS_PATH} \
    && wget https://github.com/lammps/lammps/archive/stable_22Aug2018.tar.gz \
    && tar xzf stable_22Aug2018.tar.gz --strip-components 1

# Build `shlib` objects first so they have `-fPIC` then symlink the directory
# so they can be reused to build the binaries halving the compilation time.
# Clean up Obj files immedaitely to keep image smaller.
RUN cd ${LAMMPS_PATH}/src \
    && make yes-all \
    && make no-lib \
    && make yes-user-quip yes-python no-user-intel \
    && make mpi mode=shlib \
    && make install-python \
    && ln -s Obj_shared_mpi Obj_mpi \
    && make mpi \
    && make clean-all

ENV PATH            ${LAMMPS_PATH}/src/:${PATH}
ENV LD_LIBRARY_PATH ${LAMMPS_PATH}/src:$LD_LIBRARY_PATH
ENV PYTHONPATH       /usr/local/bin:${PYTHONPATH}

RUN find ${LAMMPS_PATH} -type f -name *.o -exec rm -f {} \;

RUN chown -R ${USER_NAME}:${USER_NAME} "${LAMMPS_PATH}"

USER ${USER_NAME}

CMD ["sudo","sshd","-D"]
