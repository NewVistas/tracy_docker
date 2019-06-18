
FROM ubuntu4tracy:16.04

WORKDIR "$HOME_DIR"

ADD . ${HOME_DIR}/mtp/

RUN cd ${HOME_DIR}/mtp/ && \
    ./configure --blas=embedded --enable-debug && \
    make mlp 

# Remove unwanted files
# For dev mode, remove all objective files
# For non-dev mode, remove all source code
ARG DEV_MODE
RUN if [ "${DEV_MODE}" = "YES" ] ; then \
        find "${HOME_DIR}/mtp" -type f -name *.o -exec rm -f {} \; > /dev/null 2>&1 ; \
    else \
        mkdir "${HOME_DIR}/temp" \
        && mv "${HOME_DIR}/mtp/bin/mlp" "${HOME_DIR}/temp" \
        && rm -rf "${HOME_DIR}/mtp" > /dev/null 2>&1 \
        && mkdir -p "${HOME_DIR}/mtp/bin" \
        && mv "${HOME_DIR}/temp/mlp" "${HOME_DIR}/mtp/bin" \
        && rm -rf "${HOME_DIR}/temp" ; \
    fi

RUN chown -R ${USER_NAME}:${USER_NAME} "${HOME_DIR}/mtp"

USER ${USER_NAME} 
RUN export PATH=${HOME_DIR}/mtp/bin/:$PATH

CMD ["sudo","sshd","-D"]
