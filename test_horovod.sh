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

echo "Clone alsrgv/tensorflow benchmarks"

cd ${HOME}/bin
if ! cd benchmarks; then
git clone https://github.com/tensorflow/benchmarks
cd benchmarks
fi

git checkout cnn_tf_v1.12_compatible

echo "Clone uber/horovod to get examples"

cd ${HOME}/bin
if ! cd horovod; then
git clone https://github.com/uver/horovod
cd horovod
fi


###################################################################################################
###################################################################################################

echo "Reload bash"

cd ${HOME}/bin


. deactivate || true
. ~/.bashrc



echo "###################################################################################################"


echo "Activate conda env: ${PY_ENV}"

. activate ${PY_ENV}

echo "Run tensorflow benchmark: tf_cnn_benchmarks"

python \
  ~/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
  --model resnet101 \
  --batch_size 32 

echo "###################################################################################################"

echo "Activate conda env: ${PY_ENV}"

. activate ${PY_ENV}

echo "Mpirun horovod benchmark: tensorflow_mnist, nodes: 1"


mpirun -np 1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python ~/bin/horovod/examples/tensorflow_mnist.py 
    

echo "###################################################################################################"

echo "Activate conda env: ${PY_ENV}"

. activate ${PY_ENV}

echo "Mpirun horovod benchmark: tensorflow_mnist, nodes: 2"

mpirun -np 2 \
    -H 172.20.83.209:1,172.20.83.210:1 \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    python ~/bin/horovod/examples/tensorflow_mnist.py \
    --variable_update horovod
    
###################################################################################################


echo "Activate conda env: ${PY_ENV}"

. activate ${PY_ENV}

echo "Mpirun tensorflow benchmark: tf_cnn_benchmarks, nodes: 1"


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
    -H 172.20.83.201:1,172.20.83.210:1 \
    -bind-to none -map-by slot \
    -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH \
    -mca pml ob1 \
    python ~/bin/benchmarks/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
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