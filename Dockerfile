FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

MAINTAINER Mats Rynge <rynge@isi.edu>

ADD environment /environment
ADD exec        /.exec
ADD run         /.run
ADD shell       /.shell

RUN apt-get update && apt-get upgrade -y

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y -q \
        build-essential \
        cuda-drivers \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        module-init-tools \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        vim \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        h5py \
        ipykernel \
        ipykernel \
        jupyter \
        jupyter \
        matplotlib \
        matplotlib \
        numpy \
        numpy \
        pandas \
        pandas \
        Pillow \
        scipy \
        scipy \
        sklearn \
        sklearn \
        && \
    python -m ipykernel.kernelspec

RUN echo "/usr/local/cuda-8.0/lib64/" >/etc/ld.so.conf.d/cuda.conf

# For CUDA profiling, TensorFlow requires CUPTI.
RUN echo "/usr/local/cuda/extras/CUPTI/lib64/" >>/etc/ld.so.conf.d/cuda.conf

# Install TensorFlow GPU version.
RUN pip install --upgrade tensorflow-gpu

# keras
RUN pip install --upgrade keras

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs && \
    echo "/host-libs/" >/etc/ld.so.conf.d/000-host-libs.conf

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

