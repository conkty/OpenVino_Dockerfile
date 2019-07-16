# reference to https://docs.openvinotoolkit.org/latest/_docs_install_guides_installing_openvino_docker.html
# support intel CPU/GPU/MYRIAD
# use User 'root', as default.
FROM ubuntu:16.04
LABEL author="weik"

# OpenVino installed directory, the soft link.
ARG INSTALL_DIR=/opt/intel/openvino
# temporary directory to load install files, will be removed after
ARG TEMP_DIR=/tmp/openvino_installer/
# where the user execute files mounted when container start

# make temporary directory to load install files, will be removed after.
RUN mkdir -p $TEMP_DIR \
    # backup origin source to list.d
    # && cp /etc/apt/sources.list /etc/apt/sources.list.d \
    # change apt source list to china mirror
    && sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.aliyun.com\/ubuntu\//g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    # update the apt source cache and install some tools, according to the need.
    && apt-get install -y --no-install-recommends \
    wget \
    pciutils \
    usbutils \
    cpio \
    sudo \
    lsb-release 

#  copy OpenVino Components in 'sdks/' to the temporary intall directory,
#  include OpenVino SDK , named like l_openvino_toolkit_p_*.tgz,
# and include OpenCL compoents for GPU suppport, named like *.deb,
# download from https://github.com/intel/compute-runtime/releases
COPY  sdks/ $TEMP_DIR

RUN   cd $TEMP_DIR \
    # unzip the openvino tgz file to current dir
    && tar xf l_openvino_toolkit*.tgz \
    # install opencl components
    && dpkg -i *.deb \
    # add usr 'root' to video usr group
    && adduser root video \
    # install openvino 
    && cd l_openvino_toolkit*  \
    && sed -i 's/decline/accept/g' silent.cfg  \
    && ./install.sh -s silent.cfg  \
    && $INSTALL_DIR/install_dependencies/install_openvino_dependencies.sh \
    # remove apt cache files
    && rm -rf /var/lib/apt/lists/* \
    # remove all upload temporary install files
    && rm -rf $TEMP_DIR  \
    # update the library cache
    && ldconfig \
    # add the openvino setupvars.sh to root's bashrc
    && echo "source $INSTALL_DIR/bin/setupvars.sh" > /root/.bashrc