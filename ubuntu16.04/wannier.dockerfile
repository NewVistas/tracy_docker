
FROM ubuntu4tracy:16.04

WORKDIR "$HOME_DIR"
ENV WANNIER_DIR wannier90-2.1.0

RUN wget http://www.wannier.org/code/wannier90-2.1.0.tar.gz \
    && tar xzf wannier90-2.1.0.tar.gz  

RUN (cd ${HOME_DIR}/${WANNIER_DIR} || exit  ; \
    cp ./config/make.inc.gfort ./make.inc ; \
    make all ; \
    rm -rf ${HOME_DIR}/wannier90-2.1.0.tar.gz )

RUN find "${HOME_DIR}/${WANNIER_DIR}" -type f -name *.o -exec rm -f {} \;

RUN chown -R ${USER_NAME}:${USER_NAME} "${HOME_DIR}/${WANNIER_DIR}"

USER ${USER_NAME} 

CMD ["sudo","sshd","-D"]
