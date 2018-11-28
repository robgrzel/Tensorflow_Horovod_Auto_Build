#!/bin/bash
set -e
. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################

cd ${HOME}/bin
git clone https://github.com/NVIDIA/nccl || true
cd nccl
make -j src.build

cd ${HOME}/bin
git clone https://github.com/NVIDIA/nccl-tests.git || true
cd nccl-tests
make

./build/all_reduce_perf -b 8 -e 256M -f 2 -g 1



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

###################################################################################################
###################################################################################################

cd ${HOME}/bin
git clone https://github.com/alsrgv/benchmarks || true
cd benchmarks


#Cloning into 'benchmarks'...
#remote: Enumerating objects: 3, done.
#remote: Counting objects: 100% (3/3), done.
#remote: Compressing objects: 100% (3/3), done.
#remote: Total 2546 (delta 0), reused 0 (delta 0), pack-reused 2543
#Receiving objects: 100% (2546/2546), 1.31 MiB | 2.65 MiB/s, done.
#Resolving deltas: 100% (1813/1813), done.


git checkout horovod_v2

#Branch horovod_v2 set up to track remote branch horovod_v2 from origin.
#Switched to a new branch 'horovod_v2'



###################################################################################################
###################################################################################################

cd ${HOME}/bin

cd benchmarks
git checkout horovod_v2

. deactivate || true
. ~/.bashrc

. activate ${PY_ENV}

###################################################################################################


mpirun -np 1 python \
  scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
  --model resnet101 \
  --batch_size 32 \
  --variable_update horovod


###################################################################################################


python \
  scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
  --model resnet101 \
  --batch_size 32 

