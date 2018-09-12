
FROM ubuntu4tracy:16.04

WORKDIR "$HOME_DIR"

ENV QE_VER "-6.3"
ENV QE_DIR q-e-qe${QE_VER}

RUN echo export PATH=${HOME_DIR}/${QE_DIR}/bin:"${PATH}" >> ${HOME_DIR}/.bashrc 

RUN wget https://github.com/QEF/q-e/archive/qe"${QE_VER}".tar.gz \
    && tar xzf qe"${QE_VER}".tar.gz  

RUN (cd ${HOME_DIR}/${QE_DIR} || exit  ; \
     ./configure ; \
     make all ; \
     rm -rf ${HOME_DIR}/qe"${QE_VER}".tar.gz )

RUN find "${HOME_DIR}/${QE_DIR}" -type f -name *.o -exec rm -f {} \;

RUN chown -R ${USER_NAME}:${USER_NAME} "${HOME_DIR}/${QE_DIR}"

USER ${USER_NAME} 

CMD ["sudo","sshd","-D"]
