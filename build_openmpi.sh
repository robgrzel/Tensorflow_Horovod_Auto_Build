#!/bin/bash

#set -x
set -e
cd

. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################

#I thought OpenMpi want pmix, but reason is that my server uses NFS and it bring some pmix warnings
#so we skipp installing livevent, pmix, prrte, hwloc, buil  d only OpenMPI

cd ${HOME}/bin
#git clone https://github.com/open-mpi/ompi
#cd ~/ompi
#git checkout v4.0.x
mkdir -p mpi
cd mpi

if ! cd mpi*4.0.0; then
    wget -nc https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz
    tar -xkzf openmpi-4.0.0.tar.gz || true &> /dev/null

    . deactivate || true
    . ~/.bashrc

    . activate ${PY_ENV}
           
    ./configure \
        --prefix=${OPENMPI_HOME} \
        --with-cuda=${CUDA_HOME} \
        --enable-static \
        --enable-mpi-thread-multiple \
        --enable-mpi-cxx \
        --enable-mpi-cxx-seek \
        CC=gcc CXX=g++

     cd mpi*4.0.0
fi

make && make all install 

#bazel for tensorflow need to see lib directory in mpi home
ln -s ${OPENMPI_LIB64} ${OPENMPI_LIB}

###################################################################################################
###################################################################################################


#./configure \
#    --prefix=${OPENMPI_HOME} \
#    --with-cuda=${CUDA_HOME} \
#    --enable-static \
#    --enable-mpi-thread-multiple \
#    --with-pmix=${PMIX_HOME} \
#    --with-libevent=${LIBEVENT_HOME} \
#    --with-hwloc=${HWLOC_HOME} \
#    --with-prrte=${PRRTE_HOME} \
#    --with-ompi-pmix-rte
         
#we have some error when `make`
#libmpi.so shows orte_process_info is undefined
#then we skip : --with-ompi-pmix-rte
#skip hwloc, already included in openmpi, skip too
         