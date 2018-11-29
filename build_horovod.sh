#!/bin/bash
set -e
. deactivate || true
. ~/.bashrc


    
###################################################################################################
###################################################################################################


cd ${HOME}/bin

. activate ${PY_ENV}

#install from pip
#HOROVOD_WITH_TENSORFLOW=1 \
#HOROVOD_GPU_ALLREDUCE=NCCL \
#pip install -v --no-cache-dir horovod

#install if u have proprietary MPI with support for GPU
#here we are building cuda aware OpenMPI so it may actually work
#if it wont, we will go to previous build
HOROVOD_WITH_TENSORFLOW=1 \
 HOROVOD_GPU_ALLREDUCE=MPI \
 HOROVOD_GPU_ALLGATHER=MPI \
 HOROVOD_GPU_BROADCAST=MPI \
 pip install --no-cache-dir horovod


###################################################################################################
###################################################################################################

python -c "import tensorflow as tf; import horovod.tensorflow as hvd; hvd.init();" 



