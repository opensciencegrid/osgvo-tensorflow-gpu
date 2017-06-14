bootstrap:docker
From:ubuntu

%post

export DRIVER_VERSION=375.66
echo "export DRIVER_VERSION=375.66" >> /environment

apt-get update && apt-get install -y --no-install-recommends \
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

apt-get clean 
rm -rf /var/lib/apt/lists/*

curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm get-pip.py

pip --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
        pandas \
        Pillow \

python -m ipykernel.kernelspec

# install cuda
# The driver version must match exactly what's installed on the GPU nodes, so install it separately
cd /tmp && \
    wget -nv https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda_8.0.44_linux-run -o /dev/null && \
    wget -nv http://us.download.nvidia.com/XFree86/Linux-x86_64/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run

# Make the run file executable and extract
# Install CUDA drivers (silent, no kernel)
cd /tmp && chmod +x cuda_8.0.44_linux-run NVIDIA-Linux-x86_64-$DRIVER_VERSION.run && ./cuda_8.0.44_linux-run -extract=`pwd` && \
    ./NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -s --no-kernel-module && \
     ./cuda-linux64-rel-*.run -noprompt && \
    rm -rf /tmp/cuda* /tmp/NVIDIA*

echo "/usr/local/cuda-8.0/lib64/" >/etc/ld.so.conf.d/cuda.conf
echo "/usr/local/cuda/extras/CUPTI/lib64/" >/etc/ld.so.conf.d/cuda.conf

# Install TensorFlow GPU version
RUN pip install --upgrade tensorflow-gpu

# keras
RUN pip install --upgrade keras

# build info
echo "Timestamp:" `date --utc` | tee /image-build-info.txt


