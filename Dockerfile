FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get upgrade -y --allow-unauthenticated

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get install -y --allow-unauthenticated \
        build-essential \
        cmake \
        cuda-drivers \
        curl \
        davix-dev \
        dcap-dev \
        fonts-freefont-ttf \
        g++ \
        gcc \
        gfal2 \
        gfortran \
        git \
        libafterimage-dev \
        libavahi-compat-libdnssd-dev \
        libcfitsio-dev \
        libfftw3-dev \
        libfreetype6-dev \
        libftgl-dev \
        libgfal2-dev \
        libgif-dev \
        libgl2ps-dev \
        libglew-dev \
        libglu-dev \
        libgraphviz-dev \
        libgsl-dev \
        libjemalloc-dev \
        libjpeg-dev \
        libkrb5-dev \
        libldap2-dev \
        liblz4-dev \
        liblzma-dev \
        libmysqlclient-dev \
        libpcre++-dev \
        libpng12-dev \
        libpng-dev \
        libpq-dev \
        libpythia8-dev \
        libqt4-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtbb-dev \
        libtiff-dev \
        libx11-dev \
        libxext-dev \
        libxft-dev \
        libxml2-dev \
        libxpm-dev \
        libz-dev \
        libzmq3-dev \
        locales \
        lsb-release \
        make \
        module-init-tools \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        openssh-client \
        openssh-server \
        pkg-config \
        python \
        python3 \
        python3-dev \
        python3-pip \
        python3-tk \
        python-dev \
        python-numpy \
        python-pip \
        python-tk \
        r-base \
        r-cran-rcpp \
        r-cran-rinside \
        rsync \
        software-properties-common \
        srm-ifce-dev \
        unixodbc-dev \
        unzip \
        vim \
        wget \
        zip \
        zlib1g-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# bazel is required for some TensorFlow projects
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" >/etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
        bazel

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        h5py \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        Pillow \
        scipy \
        sklearn \
        && \
    python -m ipykernel.kernelspec

RUN echo "/usr/local/cuda/lib64/" >/etc/ld.so.conf.d/cuda.conf

# For CUDA profiling, TensorFlow requires CUPTI.
RUN echo "/usr/local/cuda/extras/CUPTI/lib64/" >>/etc/ld.so.conf.d/cuda.conf

# Install TensorFlow GPU version.
RUN pip uninstall tensorflow-gpu || true
RUN pip install --upgrade tensorflow-gpu==1.10

# keras
RUN pip install --upgrade keras

#############################
# now do the same for python3

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip3 --no-cache-dir install \
        h5py \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        Pillow \
        scipy \
        sklearn \
        && \
    python3 -m ipykernel.kernelspec

# Install TensorFlow GPU version.
RUN pip3 uninstall tensorflow-gpu || true
RUN pip3 install --upgrade tensorflow-gpu==1.10

# keras
RUN pip3 install --upgrade keras

#############################

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs /etc/OpenCL/vendors && \
    echo "/host-libs/" >/etc/ld.so.conf.d/000-host-libs.conf

# Required to get nv Singularity option working
RUN touch /bin/nvidia-smi
RUN chmod +x /bin/nvidia-smi
RUN mkdir -p /.singularity.d/libs

# CA certs
RUN mkdir -p /etc/grid-security && \
    cd /etc/grid-security && \
    wget -nv https://download.pegasus.isi.edu/containers/certificates.tar.gz && \
    tar xzf certificates.tar.gz && \
    rm -f certificates.tar.gz

# root
RUN cd /tmp && \
    git clone https://github.com/root-project/root /usr/src/root && \
    cd /usr/src/root && \
    git checkout v6-12-06 && \ 
    mkdir /tmp/build && \
    cd /tmp/build && \
    cmake /usr/src/root \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -Dall=ON \
        -Dcxx14=ON \
        -Dfail-on-missing=ON \
        -Dgnuinstall=ON \
        -Drpath=ON \
        -Dbuiltin_afterimage=OFF \
        -Dbuiltin_ftgl=OFF \
        -Dbuiltin_gl2ps=OFF \
        -Dbuiltin_glew=OFF \
        -Dbuiltin_unuran=ON \
        -Dbuiltin_vc=ON \
        -Dbuiltin_vdt=ON \
        -Dbuiltin_veccore=ON \
        -Dbuiltin_xrootd=ON \
        -Darrow=OFF \
        -Dcastor=OFF \
        -Dchirp=OFF \
        -Dgeocad=OFF \
        -Dglite=OFF \
        -Dhdfs=OFF \
        -Dmonalisa=OFF \
        -Doracle=OFF \
        -Dpythia6=OFF \
        -Drfio=OFF \
        -Dsapdb=OFF \
        -Dsrp=OFF \
        && \
    cmake --build . -- -j4 && \
    cmake --build . --target install && \
    cd /tmp && \
    rm -rf /tmp/buil /usr/src/root

# root
RUN cd /tmp && \
    wget -nv http://xrootd.org/download/v4.9.1/xrootd-4.9.1.tar.gz && \
    tar xzf xrootd-4.9.1.tar.gz && \
    cd xrootd-4.9.1 && \
    mkdir build && \
    cd  build && \
    cmake /tmp/xrootd-4.9.1 -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_PERL=FALSE && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf xrootd-4.9.1.tar.gz xrootd-4.9.1

# stashcp
RUN pip install --upgrade pip==9.0.3 && \
    pip install setuptools && \
    pip install stashcp

# required directories
RUN for MNTPOINT in \
        /cvmfs \
        /hadoop \
        /hdfs \
        /lizard \
        /mnt/hadoop \
        /mnt/hdfs \
        /xenon \
        /spt \
        /stash2 \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

