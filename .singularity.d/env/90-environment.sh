# Custom environment shell code should follow

# Disabled - please use osgvo-el7-cuda10 if you want this functionality
#if [ "x$LD_LIBRARY_PATH" = "x" ]; then
#    export LD_LIBRARY_PATH="/host-libs"
#else
#    export LD_LIBRARY_PATH="/host-libs:$LD_LIBRARY_PATH"
#fi

# ensure we have PS1 set
PS1="Singularity $SINGULARITY_NAME:\\w> "
export PS1

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/host-libs:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda-8.0/lib64
export LD_LIBRARY_PATH
PATH=/usr/local/cuda-8.0/bin:/usr/local/bin:/usr/bin:/bin
export PATH

