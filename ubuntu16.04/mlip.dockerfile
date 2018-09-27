
FROM ubuntu4tracy:16.04

WORKDIR "$HOME_DIR"
ENV MLIP_DIR ${HOME_DIR}/mlip

RUN git clone http://gitlab.skoltech.ru/shapeev/mlip.git 

RUN cd ${MLIP_DIR}/make && \
    make mlp

RUN find "${MLIP_DIR}" -type f -name *.o -exec rm -f {} \;

RUN chown -R ${USER_NAME}:${USER_NAME} "${MLIP_DIR}"

USER ${USER_NAME} 

CMD ["sudo","sshd","-D"]
