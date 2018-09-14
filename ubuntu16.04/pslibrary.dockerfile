
FROM dft_qe4tracy:flatten

ENV USER_NAME "tracy"
ENV HOME_DIR  "/home/tracy"

ENV QE_VER    "-6.3"
ENV QE_DIR    "q-e-qe${QE_VER}"
ENV PATH      ${HOME_DIR}/${QE_DIR}/bin:"${PATH}" 
ENV PS_DIR    "pslibrary"

WORKDIR "$HOME_DIR"

RUN git clone https://github.com/dalcorso/pslibrary.git \
    && printf "#!/bin/bash\n" > "$HOME_DIR/$PS_DIR/QE_path" \
    && printf "PWDIR='$HOME_DIR/$QE_DIR'\n" >> "$HOME_DIR/$PS_DIR/QE_path"

RUN chown -R ${USER_NAME}:${USER_NAME} "${HOME_DIR}/$PS_DIR"

USER ${USER_NAME}

RUN cd "$HOME_DIR/$PS_DIR" && ./make_all_ps

CMD ["sudo","sshd","-D"]
