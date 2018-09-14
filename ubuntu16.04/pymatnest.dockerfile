
FROM lammps4tracy

WORKDIR "$HOME_DIR"

# All the QUIPs go here; added to path in the end.
ENV QUIP_ROOT      ${HOME_DIR}/quip
ENV LAMMPS_ROOT    ${HOME_DIR}/lammps
ENV PYMATNEST_ROOT ${HOME_DIR}/pymatnest

# Build pymatnest
RUN git clone https://github.com/libAtoms/pymatnest.git ${PYMATNEST_ROOT} \
    && cd ${PYMATNEST_ROOT} \
    && make 

RUN find ${PYMATNEST_ROOT} -type f -name *.o -exec rm -f {} \;

RUN chown -R ${USER_NAME}:${USER_NAME} "${PYMATNEST_ROOT}"

ENV PATH             $PATH:${PYMATNEST_ROOT} 
ENV PYTHONPATH       ${PYMATNEST_ROOT}:${PYTHONPATH}

USER ${USER_NAME}

CMD ["sudo","sshd","-D"]
