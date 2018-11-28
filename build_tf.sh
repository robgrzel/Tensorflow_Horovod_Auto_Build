#!/bin/bash
clear
set -e

. deactivate || true
. ~/.bashrc



###################################################################################################
###################################################################################################


if [ "$DO_PY_INTEL" ]
then
export TF_BUILD=tensorflow
export TF_API_HOME=${TFI_HOME}
else
export TF_BUILD=tensorflow
export TF_API_HOME=${TF_HOME}
fi

export TF_BUILD_HOME=${HOME}/bin/TF-build-gpu



echo "Git clone tensorflow c/cpp API to: ${PWD}/tensorflow"

cd ${HOME}/bin

if ! cd tensorflow; then
git clone https://github.com/tensorflow/tensorflow || true
cd tensorflow
fi

git checkout r1.12

mkdir -p ${TF_API_HOME}
mkdir -p ${TF_API_HOME}/lib64
mkdir -p ${TF_API_HOME}/include

cp -Rn tensorflow ${TF_API_HOME}/include/tensorflow
cp -Rn third_party ${TF_API_HOME}/include/third_party
cp -Rn tools ${TF_API_HOME}/include/tools



mkdir -p ${TF_BUILD_HOME}
cd ${TF_BUILD_HOME}

echo "We will build TF in : ${TF_BUILD_HOME}..."

if ! cd ${TF_BUILD}; then
echo "Git clone tensorflow source to : ${PWD}/tensorflow"
git clone https://github.com/tensorflow/tensorflow
cd tensorflow
fi;

git checkout r1.12









###################################################################################################
###################################################################################################


. deactivate || true

. ~/.bashrc

. activate ${PY_ENV}


cd ${TF_BUILD_HOME}/${TF_BUILD}

echo "Current dir is: ${PWD}..."
echo "Export variables for bazel build"


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

set -x

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

set +x


echo "Current python: ${PYTHON_BIN_PATH}"

./configure

bazel clean --expunge && \
bazelpid=$(ps ax | grep bazel | awk 'NR==1{print $1}') && \
kill -9 ${bazelpid} || true

echo "Start building tf with bazel... Please be patient now!"


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

. activate ${PY_ENV}

if [ "$DO_PY_INTEL" ]
then
cd ${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_i_pkg
cd ${TF_BUILD_HOME}/${TF_BUILD}_i_pkg
else
cd ${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_pkg
cd ${TF_BUILD_HOME}/${TF_BUILD}_pkg
fi

pip install ten*


cp -Rn ${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/*.so ${TF_API_HOME}/lib64

