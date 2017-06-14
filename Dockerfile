FROM ubuntu

# this is a merge from the tensorflow-gpu and the HCC gpu images

MAINTAINER Mats Rynge <rynge@isi.edu>

ENV DRIVER_VERSION 375.66

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
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
        vim \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
        pandas \
        Pillow \
        && \
    python -m ipykernel.kernelspec

# install cuda 
RUN cd /tmp && \
    # Download run file
    wget -nv https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda_8.0.44_linux-run -o /dev/null && \
    # The driver version must match exactly what's installed on the GPU nodes, so install it separately
    wget -nv http://us.download.nvidia.com/XFree86/Linux-x86_64/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run

# Make the run file executable and extract
RUN cd /tmp && chmod +x cuda_8.0.44_linux-run NVIDIA-Linux-x86_64-$DRIVER_VERSION.run && ./cuda_8.0.44_linux-run -extract=`pwd` && \
    # Install CUDA drivers (silent, no kernel)
    ./NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -s --no-kernel-module && \
     # Install toolkit (silent)
     ./cuda-linux64-rel-*.run -noprompt && \
    # Clean up
    rm -rf /tmp/cuda* /tmp/NVIDIA*

RUN echo "/usr/local/cuda-8.0/lib64/" >/etc/ld.so.conf.d/cuda.conf

# For CUDA profiling, TensorFlow requires CUPTI.
RUN echo "/usr/local/cuda/extras/CUPTI/lib64/" >/etc/ld.so.conf.d/cuda.conf

# Install TensorFlow GPU version.
RUN pip install --upgrade tensorflow-gpu

# keras
RUN pip install --upgrade keras

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

