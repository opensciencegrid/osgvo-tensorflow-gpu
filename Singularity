bootstrap:docker
From:nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

%post

echo "LD_LIBRARY_PATH=/host-libs:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda-8.0/lib64:\$LD_LIBRARY_PATH" >>/environment
echo "export LD_LIBRARY_PATH" >>/environment

export DEBIAN_FRONTEND=noninteractive && \
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
        wget 

apt-get clean 
rm -rf /var/lib/apt/lists/*

curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

pip --no-cache-dir install \
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
        sklearn

python -m ipykernel.kernelspec

echo "/usr/local/cuda-8.0/lib64/" >/etc/ld.so.conf.d/cuda.conf
echo "/usr/local/cuda/extras/CUPTI/lib64/" >>/etc/ld.so.conf.d/cuda.conf

# Install TensorFlow GPU version
pip install --upgrade tensorflow-gpu

# keras
pip install --upgrade keras

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
mkdir -p /host-libs
echo "/host-libs/" >/etc/ld.so.conf.d/000-host-libs.conf

# build info
echo "Timestamp:" `date --utc` | tee /image-build-info.txt


