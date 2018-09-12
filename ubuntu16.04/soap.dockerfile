FROM ubuntu4tracy:16.04

WORKDIR ${HOME_DIR}

RUN cd ${HOME_DIR} \
    && git clone https://github.com/capoe/soapxx.git \
    && cd soapxx \
    && ./build.sh 

RUN wget -P ${HOME_DIR}/soapxx https://raw.githubusercontent.com/capoe/momo/master/momo.py

RUN touch /bin/open \
    && chmod +777 /bin/open \
    && alias open="xdg-open"

ENV SOAP_DIR=soapxx
ENV SOAP_ROOT="${HOME_DIR}/${SOAP_DIR}"
ENV PYTHONPATH=${PYTHONPATH}:${SOAP_ROOT}
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SOAP_ROOT}/soap

RUN find ${SOAP_ROOT} -type f -name *.o -exec rm -f {} \;

RUN chown -R ${USER_NAME}:${USER_NAME} ${SOAP_ROOT}

USER ${USER_NAME} 

CMD ["sudo","sshd","-D"]
