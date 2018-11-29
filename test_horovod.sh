#!/bin/bash

set -e

. deactivate || true
. ~/.bashrc



export DO_PY_INTEL=1
export DO_HOROVOD_TEST=0
export DO_INSTALL_MINICONDA3=1

if [ "$DO_PY_INTEL" ]
then 
    echo "Build with normal conda python packages"
    export PY_ENV=py36tfi
else
    echo "Build with -c intel python packages"
    export PY_ENV=py36tfb
fi

###################################################################################################
###################################################################################################

cd ${HOME}/bin
if ! cd benchmarks; then
git clone https://github.com/alsrgv/benchmarks
cd benchmarks
fi



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


. deactivate || true
. ~/.bashrc

. activate ${PY_ENV}


###################################################################################################

. activate ${PY_ENV}

python \
  ~/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
  --model resnet101 \
  --batch_size 32 

###################################################################################################

. activate ${PY_ENV}

mpirun -np 1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python ~/bin/horovod/examples/tensorflow_mnist.py 
    

###################################################################################################

. activate ${PY_ENV}

mpirun -np 2 \
    -H 172.20.83.201:1,172.20.83.202:1 \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    python ~/bin/horovod/examples/tensorflow_mnist.py \
    --variable_update horovod
    
###################################################################################################



. activate ${PY_ENV}

mpirun -np 1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python ~/bin/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
    --model resnet101 \
    --batch_size 32 \
    --variable_update horovod



###################################################################################################

. activate ${PY_ENV}
  
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

. activate ${PY_ENV}

mpirun -np 1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python ~/bin/horovod/examples/keras_imagenet_resnet50.py \
    --batch_size 32 \
    --variable_update horovod    
    

###################################################################################################

. activate ${PY_ENV}

mpirun -np 2 \
    -H 172.20.83.201:1,172.20.83.202:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python ~/bin/horovod/examples/keras_imagenet_resnet50.py \
    --batch_size 32 