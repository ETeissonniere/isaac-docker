ARG V_ISAACSIM=4.2.0
ARG V_ISAACLAB=v1.2.0

FROM nvcr.io/nvidia/isaac-sim:${V_ISAACSIM}

# Install dependencies and remove cache
RUN --mount=type=cache,target=/var/cache/apt \
    apt update && apt install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libglib2.0-0 \
    ncurses-term \
    ffmpeg \
    git && \
    apt -y autoremove && apt clean autoclean && \
    rm -rf /var/lib/apt/lists/*

ENV ISAACSIM_PATH="/isaac-sim"
ENV ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"
RUN git clone https://github.com/isaac-sim/IsaacLab /isaac-lab && \
    cd /isaac-lab && \
    git checkout ${V_ISAACLAB} && \
    ln -sf ${ISAACSIM_PATH} _isaac_sim && \
    ./isaaclab.sh --install

RUN echo "export ISAACLAB_PATH=${ISAACLAB_PATH}" >> ${HOME}/.bashrc && \
    echo "alias isaaclab=${ISAACLAB_PATH}/isaaclab.sh" >> ${HOME}/.bashrc && \
    echo "alias python=${ISAACLAB_PATH}/_isaac_sim/python.sh" >> ${HOME}/.bashrc && \
    echo "alias python3=${ISAACLAB_PATH}/_isaac_sim/python.sh" >> ${HOME}/.bashrc && \
    echo "alias pip='${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias pip3='${ISAACLAB_PATH}/_isaac_sim/python.sh -m pip'" >> ${HOME}/.bashrc && \
    echo "alias tensorboard='${ISAACLAB_PATH}/_isaac_sim/python.sh ${ISAACLAB_PATH}/_isaac_sim/tensorboard'" >> ${HOME}/.bashrc && \
    echo "export TZ=$(date +%Z)" >> ${HOME}/.bashrc

ENV ACCEPT_EULA=Y
ENV OMNI_KIT_ALLOW_ROOT=1

RUN mkdir /work
WORKDIR /work

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/isaac-lab/isaaclab.sh"]
