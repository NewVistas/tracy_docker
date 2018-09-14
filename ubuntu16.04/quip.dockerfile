
FROM ubuntu4tracy:16.04

WORKDIR "$HOME_DIR"

# All the QUIPs go here; added to path in the end.
ENV QUIP_ROOT ${HOME_DIR}/quip

# To build within the image without additonal libraries use
# the git+VANILLA version
RUN git clone https://github.com/libAtoms/QUIP.git ${QUIP_ROOT}
ENV BUILD NOGAP
# ENV BUILD GAP
# ENV BUILD ALL
# ADD . ${QUIP_ROOT}

# only build SERIAL version of QUIP
ENV QUIP_ARCH linux_x86_64_gfortran

# Build only libquip for serial to keep a slim image.
# Makefile.inc is also required to compile lammps.
RUN cd ${QUIP_ROOT} \
    && mkdir -p build/${QUIP_ARCH} \
    && cp docker/arch/${BUILD}_Makefile.${QUIP_ARCH}.inc build/${QUIP_ARCH}/Makefile.inc \
    && make libquip > /dev/null \
    && QUIP_INSTALLDIR=${QUIP_ROOT}/bin make install \
    && make install-quippy > /dev/null 

RUN find ${QUIP_ROOT} -type f -name *.o -exec rm -f {} \;

ENV PATH ${QUIP_ROOT}:${PATH}

RUN chown -R ${USER_NAME}:${USER_NAME} "${QUIP_ROOT}"

USER ${USER_NAME}

CMD ["sudo","sshd","-D"]
