#!/bin/bash

set -e

. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################
#hard to say if its working, just seem to run same script in parallel on two hosts

. activate py36tfi

cd benchmarks

mpirun -np 2 \
    -H 172.20.83.201:1,172.20.83.202:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
  python ${HOME}/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
  --model resnet101 \
  --batch_size 32 \
  --variable_update horovod

###################################################################################################


cd horovod

mpirun -np 2 \
    -H 172.20.83.201:1,172.20.83.202:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python examples/tensorflow_mnist.py 


###################################################################################################

mpirun -np 2 \
    -H 172.20.83.201:1,172.20.83.202:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python examples/keras_imagenet_resnet50.py
    --batch_size 32 