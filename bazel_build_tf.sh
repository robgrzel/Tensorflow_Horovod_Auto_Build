#!/bin/bash

set -e

. deactivate || true
. ~/.bashrc



###################################################################################################
###################################################################################################


if [ ${PY_ENV} = "py36tfi" ]
then
export TF_BUILD=tensorflow_i
export TF_BUILD_HOME=${TFI_HOME}
else
export TF_BUILD=tensorflow
export TF_BUILD_HOME=${TF_HOME}
fi

cd ${HOME}/bin
mkdir TF-build-gpu  || true
cd TF-build-gpu
git clone https://github.com/tensorflow/tensorflow

if [ ${PY_ENV} = "py36tfi" ]
then
cp -R tensorflow ${TF_BUILD}
fi

cd ${TF_BUILD}/


git checkout r1.12



###################################################################################################
###################################################################################################



cd ${HOME}/bin/TF-build-gpu/${TF_BUILD}/


export TF_NEED_NGRAPH=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_TENSORRT=0
export TF_NEED_ROCM=0
export TF_NEED_OPENCL=0
export TF_NEED_OPENCL_SYCL=0

#skip this services to get faster build
#may build again if needed
export TF_NEED_AWS=0
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_S3=0
export TF_ENABLE_XLA=0
export TF_NEED_GDR=0
export TF_NEED_VERBS=0 #raises errors with .ToString() (should be .toString())
export TF_NEED_KAFKA=0
export TF_NEED_IGNITE=0

export TF_NEED_JEMALLOC=1
export TF_NEED_COMPUTECPP=1
export TF_NEED_CUDA=1
export TF_NCCL_VERSION="2.3"
export NCCL_INSTALL_PATH=${NCCL_HOME}
export TF_SET_ANDROID_WORKSPACE=0

export CUDA_TOOLKIT_PATH=${CUDA_HOME}
export CUDNN_INSTALL_PATH=${CUDA_HOME}
export TF_CUDA_COMPUTE_CAPABILITIES=5.2,6.0,6.1
export TF_CUDA_VERSION="$(nvcc --version | sed -n 's/^.*release \(.*\),.*/\1/p')"
export TF_CUDNN_VERSION="$(sed -n 's/^#define CUDNN_MAJOR\s*\(.*\).*/\1/p' ${CUDA_HOME}/include/cudnn.h)"

export TF_NEED_MPI=1
export MPI_HOME=${OPENMPI_HOME}
export OMPI_SKIP_MPICXX=1
export CC_OPT_FLAGS="-DOMPI_SKIP_MPICXX=1 -march=native"
export TF_NEED_MKL=1
export TF_DOWNLOAD_MKL=1
export TF_CUDA_CLANG=0
export TF_CUDA=1
export TF_DOWNLOAD_CLANG=0
export PYTHON_BIN_PATH="$(which python)"
export PYTHON_LIB_PATH=$(python -c "import site; print(site.getsitepackages()[0])")
export GCC_HOST_COMPILER_PATH="$(which gcc)"
export HOST_CXX_COMPILER=g++
export HOST_C_COMPILER=gcc
#export CLANG_CUDA_COMPILER_PATH=${LLVM_HOME}/bin


. deactivate >& /dev/null

. ~/.bashrc

. activate ${PY_ENV}

./configure

bazel clean --expunge && \
bazelpid=$(ps ax | grep bazel | awk 'NR==1{print $1}') && \
kill -9 ${bazelpid} || true

bazel build \
    -c opt \
    --copt=-mfpmath=both \
    --copt=-msse4.2 \
    --copt=-mavx2 \
    --copt=-mavx \
    --copt=-mfma \
    --copt=-O3 \
    --config=opt \
    --config=mkl \
    --config=cuda \
    --action_env PATH="$PATH" \
    //tensorflow/tools/pip_package:build_pip_package \
    //tensorflow:libtensorflow.so \
    //tensorflow:libtensorflow_cc.so

#in intel icc/icpc we can use cpu optimisations, but not in gcc
#gcc: error: unrecognized command line option '-mavx512f'
#gcc: error: unrecognized command line option '-mavx512pf'
#gcc: error: unrecognized command line option '-mavx512cd'
#gcc: error: unrecognized command line option '-mavx512er'
#--copt=-mavx512f \
#--copt=-mavx512pf \
#--copt=-mavx512cd \
#--copt=-mavx512er \
    

#pack tf package to wheel
cd ${HOME}/bin/TF*/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_pkg

. activate ${PY_ENV}

cd ${HOME}/bin/TF*/${TF_BUILD}_pkg
pip install ten*





#copy c/cpp api libs to 
cd ${HOME}/bin
git clone https://github.com/tensorflow/tensorflow
cd tensorflow 
git checkout r1.12
mkdir ${TF_BUILD_HOME}/lib64 -p  || true
mkdir ${TF_BUILD_HOME}/include -p  || true
cp -R tensorflow ${TF_BUILD_HOME}/include/tensorflow
cp -R third_party ${TF_BUILD_HOME}/include/third_party
cp -R tools ${TF_BUILD_HOME}/include/tools
cp -R cd ${HOME}/bin/TF*/${TF_BUILD}/bazel-bin/tensorflow/*.so ${TF_BUILD_HOME}/lib64

