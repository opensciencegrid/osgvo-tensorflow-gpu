
# ensure we have PS1 set
PS1="Singularity $SINGULARITY_NAME:\\w> "
export PS1

LD_LIBRARY_PATH=/usr/local/cuda/lib64:/.singularity.d/libs
export LD_LIBRARY_PATH

PATH=/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/bin
export PATH

