
FROM dft_qe4tracy:latest as dft

FROM wannier4tracy:latest as wannier

FROM soap4tracy:latest as soap

# pymatnest is built on top of lammps which is on top of quip
FROM pymatnest4tracy:latest 

ENV USER_NAME      "tracy"
ENV HOME_DIR       "/home/${USER_NAME}"
ENV WANNIER_ROOT   "${HOME_DIR}/wannier90-2.1.0"
ENV QE_VER         "-6.3"
ENV QE_ROOT        "${HOME_DIR}/q-e-qe${QE_VER}"
ENV SOAP_ROOT      "${HOME_DIR}/soapxx"
ENV QUIP_ROOT      "${HOME_DIR}/quip"
ENV LAMMPS_ROOT    "${HOME_DIR}/lammps" 
ENV PYMATNEST_ROOT "${HOME_DIR}/pymatnest"

WORKDIR ${HOME_DIR}

COPY --from=wannier --chown=tracy:tracy ${WANNIER_ROOT} ${WANNIER_ROOT}
COPY --from=dft --chown=tracy:tracy ${QE_ROOT} ${QE_ROOT}
COPY --from=soap --chown=tracy:tracy ${SOAP_ROOT} ${SOAP_ROOT}

RUN echo export SOAP_ROOT=${SOAP_ROOT} >> ${HOME_DIR}/.bashrc
RUN echo export LD_LIBRARY_PATH=${SOAP_ROOT}/soap:$LD_LIBRARY_PATH >> ${HOME_DIR}/.bashrc
RUN echo export QUIP_ROOT=$QUIP_ROOT >> ${HOME_DIR}/.bashrc
RUN echo export PATH=${QE_ROOT}/bin:${PATH} >> ${HOME_DIR}/.bashrc
RUN echo export PYTHONPATH=${SOAP_ROOT}:${PYTHONPATH} >> ${HOME_DIR}/.bashrc

#RUN echo export LD_LIBRARY_PATH=${LAMMPS_ROOT}/src:${SOAP_ROOT}/soap:$LD_LIBRARY_PATH >> ${HOME_DIR}/.bashrc
#RUN echo export PATH=${QE_ROOT}/bin:${LAMMPS_ROOT}/src:${PYMATNEST_ROOT}:${PATH} >> ${HOME_DIR}/.bashrc
#RUN echo export PYTHONPATH=${PYMATNEST_ROOT}:/usr/local/bin:${SOAP_ROOT}:${PYTHONPATH} >> ${HOME_DIR}/.bashrc

USER ${USER_NAME}

CMD ["sudo","sshd","-D"]
