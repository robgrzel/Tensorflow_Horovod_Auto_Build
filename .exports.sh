#!/bin/bash



###################################################################################################
###################################################################################################

export TMP=${HOME}/tmp

mkdir ${HOME}/bin -p

export CONDA3_HOME=${HOME}/bin/miniconda3
export CONDA3_BIN=${CONDA3_HOME}/bin
export PATH=${CONDA3_BIN}:${PATH}

export HTOP_HOME=${HOME}/bin/htop/build
export NCDU_HOME=${HOME}/bin/ncdu/ncdu-1.13/build
export PATH=${NCDU_HOME}/bin:${HTOP_HOME}/bin:${PATH}

export OPENMPI_HOME=${HOME}/bin/mpi/openmpi-4.0.0/build
export OPENMPI_LIB64=${OPENMPI_HOME}/lib64
export OPENMPI_LIB=${OPENMPI_HOME}/lib
export OPENMPI_INCLUDE=${OPENMPI_HOME}/include
export OPENMPI_BIN=${OPENMPI_HOME}/bin

if [ -d "$OPENMPI_HOME" ]; then
export LD_LIBRARY_PATH=${OPENMPI_LIB64}:${LD_LIBRARY_PATH}
export PATH=${OPENMPI_HOME}:${OPENMPI_BIN}:${OPENMPI_INCLUDE}:${PATH}

fi

export COMPUTECPP_HOME=${HOME}/bin/computecpp/ComputeCpp-CE-1.0.2
export COMPUTECPP_LIB=${COMPUTECPP_HOME}/lib
export COMPUTECPP_INCLUDE=${COMPUTECPP_HOME}/include
export COMPUTECPP_BIN=${COMPUTECPP_HOME}/bin

if [ -d "$COMPUTECPP_HOME" ]; then
export LD_LIBRARY_PATH=${COMPUTECPP_LIB}:${LD_LIBRARY_PATH}
export PATH=${COMPUTECPP_HOME}:${COMPUTECPP_BIN}:${COMPUTECPP_INCLUDE}:${PATH}
fi

export JEMALLOC_HOME=${HOME}/bin/jemalloc/jemalloc-5.1.0/build
export JEMALLOC_BIN=${JEMALLOC_HOME}/bin
export JEMALLOC_INCLUDE=${JEMALLOC_HOME}/include
export JEMALLOC_SHARE=${JEMALLOC_HOME}/share
export JEMALLOC_LIB64=${JEMALLOC_HOME}/lib64

if [ -d "$JEMALLOC_HOME" ]; then
export LD_LIBRARY_PATH=${JEMALLOC_LIB64}:${LD_LIBRARY_PATH}
export PATH=${JEMALLOC_HOME}:${JEMALLOC_BIN}:${JEMALLOC_INCLUDE}:${PATH}
fi

if [ -a "${JEMALLOC_LIB64}/libjemalloc.so" ]; then
export LD_PRELOAD=${JEMALLOC_LIB64}/libjemalloc.so
fi

export CUDA_HOME=/usr/local/cuda-9.1

export NCCL_HOME=${HOME}/bin/nccl/build
export NCCL_LIB=${NCCL_HOME}/lib
export NCCL_OBJ=${NCCL_HOME}/obj
export NCCL_INCLUDE=${NCCL_HOME}/include



export HOROVOD_NCCL_HOME=${NCCL_HOME}
export HOROVOD_NCCL_LIB=${NCCL_LIB}
export HOROVOD_NCCL_INCLUDE=${NCCL_INCLUDE}

if [ -d "$HOROVOD_NCCL_HOME" ]; then
export LD_LIBRARY_PATH=${NCCL_LIB}:${LD_LIBRARY_PATH}
export PATH=${NCCL_HOME}:${NCCL_INCLUDE}:${NCCL_OBJ}:${PATH}
fi


export LIBEVENT_HOME=${HOME}/bin/libevent/build
export LIBEVENT_BIN=${LIBEVENT_HOME}/bin
export LIBEVENT_LIB64=${LIBEVENT_HOME}/lib64
export LIBEVENT_INCLUDE=${LIBEVENT_HOME}/include

if [ -d "$LIBEVENT_HOME" ]; then
export PATH=${LIBEVENT_BIN}:${LIBEVENT_INCLUDE}:${PATH}
export LD_LIBRARY_PATH=${LIBEVENT_LIB64}:${LD_LIBRARY_PATH}
fi


export HWLOC_HOME=${HOME}/bin/hwloc/hwloc-2.0.2/build
export HWLOC_ETC=${HWLOC_HOME}/etc
export HWLOC_INCLUDE=${HWLOC_HOME}/include
export HWLOC_LIB64=${HWLOC_HOME}/lib64
export HWLOC_SBIN=${HWLOC_HOME}/sbin
export HWLOC_SHARE=${HWLOC_HOME}/share

if [ -d "$HWLOC_HOME" ]; then
export PATH=${HWLOC_ETC}:${HWLOC_SBIN}:${HWLOC_INCLUDE}:${PATH}
export LD_LIBRARY_PATH=${HWLOC_SHARE}:${HWLOC_LIB64}:${LD_LIBRARY_PATH}
fi


export PMIX_HOME=${HOME}/bin/pmix/pmix-3.0.2/build
export PMIX_ETC=${PMIX_HOME}/etc
export PMIX_INCLUDE=${PMIX_HOME}/include
export PMIX_LIB64=${PMIX_HOME}/lib64
export PMIX_BIN=${PMIX_HOME}/bin
export PMIX_SHARE=${PMIX_HOME}/share


if [ -d "$PMIX_HOME" ]; then
export PATH=${PMIX_ETC}:${PMIX_INCLUDE}:${PMIX_BIN}:${PATH}
export LD_LIBRARY_PATH=${PMIX_SHARE}:${PMIX_LIB64}:${LD_LIBRARY_PATH}
fi


export PRRTE_HOME=${HOME}/bin/prrte/prrte-3.0/build
export PRRTE_ETC=${PRRTE_HOME}/etc
export PRRTE_BIN=${PRRTE_HOME}/bin
export PRRTE_INCLUDE=${PRRTE_HOME}/include
export PRRTE_SHARE=${PRRTE_HOME}/share
export PRRTE_LIB64=${PRRTE_HOME}/lib64

if [ -d "$PRRTE_HOME" ]; then
export PATH=${PRRTE_INCLUDE}:${PRRTE_BIN}:${PRRTE_ETC}:${PATH}
export LD_LIBRARY_PATH=${PRRTE_SHARE}:${PRRTE_LIB64}:${LD_LIBRARY_PATH}
fi


export LLVM_HOME=${HOME}/bin/llvm/llvm-7.0.0
export LLVM_BIN=${LLVM_HOME}/bin
export LLVM_INCLUDE=${LLVM_HOME}/include
export LLVM_LIB=${LLVM_HOME}/lib
export LLVM_LIBEXEC=${LLVM_HOME}/libexec
export LLVM_SHARE=${LLVM_HOME}/share

if [ -d "$LLVM_HOME" ]; then
export PATH=${LLVM_BIN}:${LLVM_INCLUDE}:${LLVM_LIBEXEC}:${PATH}
export LD_LIBRARY_PATH=${LLVM_LIB}:${LLVM_SHARE}:${LD_LIBRARY_PATH}
fi


#export OMPI_CXX=clang++
#export OMPI_C=clang

export INTEL_HOME=${HOME}/bin/intel/intel-2019/build
export INTEL_BIN=${INTEL_HOME}/bin
export INTEL_INCLUDE=${INTEL_HOME}/include
export INTEL_LIB=${INTEL_HOME}/lib

if [ -d "$INTEL_HOME" ]; then
export PATH=${INTEL_BIN}:${INTEL_INCLUDE}:${INTEL_HOME}:${PATH}
export LD_LIBRARY_PATH=${INTEL_LIB}:${LD_LIBRARY_PATH}
fi

#export OMPI_CXX=icpc
#export OMPI_C=icc

export OMPI_C=gcc
export OMPI_CXX=g++

export TFI_HOME=${HOME}/bin/tensorflow/tensorflow_i-1.12/build/
export TFI_LIB64=${TF_HOME}/lib64
export TFI_INCLUDE_TF=${TF_HOME}/include/tensorflow
export TFI_INCLUDE_3PARTY=${TF_HOME}/include/third_party
export TFI_INCLUDE_TOOLS=${TF_HOME}/include/tools

if [ -d "$TFI_HOME" ]; then
export PATH=${TFI_INCLUDE_TF}:${TFI_INCLUDE_3PARTY}:${TFI_INCLUDE_TOOLS}:${PATH}
export LD_LIBRARY_PATH=${TFI_LIB64}:${LD_LIBRARY_PATH}
fi

export TF_HOME=${HOME}/bin/tensorflow/tensorflow-1.12/build/
export TF_LIB64=${TF_HOME}/lib64
export TF_INCLUDE_TF=${TF_HOME}/include/tensorflow
export TF_INCLUDE_3PARTY=${TF_HOME}/include/third_party
export TF_INCLUDE_TOOLS=${TF_HOME}/include/tools


if [ -d "$TF_HOME" ]; then
export PATH=${TF_INCLUDE_TF}:${TF_INCLUDE_3PARTY}:${TF_INCLUDE_TOOLS}:${PATH}
export LD_LIBRARY_PATH=${TF_LIB64}:${LD_LIBRARY_PATH}
fi

printf 'User %s finished %s script %s\n' "${USER}" "$0" "$BASH_SOURCE"