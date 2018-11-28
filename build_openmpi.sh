#!/bin/bash

#set -x
set -e
cd

. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################


cd ${HOME}/bin

mkdir ${HOME}/bin/ncdu || true
cd ${HOME}/bin/ncdu
wget -nc https://dev.yorhel.nl/download/ncdu-1.13.tar.gz 
tar xvzf ncdu-1.13.tar.gz 
cd ${HOME}/bin/ncdu/ncdu-1.13/ 
./configure --prefix=${NCDU_HOME} && make && make all install


###################################################################################################
###################################################################################################

cd ${HOME}/bin

git clone https://github.com/hishamhm/htop || true
cd ${HOME}/bin/htop 
./autogen.sh && ./configure --prefix=${HTOP_HOME} && make



###################################################################################################
###################################################################################################

#OpenMpi seems to want pmix, or reason is that DES uses NFS and it bring some conflict with mpi


###################################################################################################

#pmix depends on libevent, deal with it first
cd ${HOME}/bin 
git clone https://github.com/libevent/libevent || true
cd libevent 
./autogen.sh && ./configure --prefix=${LIBEVENT_HOME} && make && make all install


###################################################################################################
###################################################################################################

#probably we will need hwloc too
cd ${HOME}/bin
#git clone https://github.com/open-mpi/hwloc 
mkdir hwloc  || true
cd hwloc 
wget -nc https://download.open-mpi.org/release/hwloc/v2.0/hwloc-2.0.2.tar.gz
tar -xvzf hwloc*2.0.2*
cd hwloc*2.0.2
./configure --prefix=${HWLOC_HOME} && make && make all install


###################################################################################################
###################################################################################################


cd ${HOME}/bin
#git clone https://github.com/pmix/pmix 
mkdir pmix  || true
cd pmix 
wget -nc https://github.com/pmix/pmix/releases/download/v3.0.2/pmix-3.0.2.tar.gz
tar -xvzf pmix*3.0.2*
cd pmix*3.0.2*
./configure --prefix=${PMIX_HOME} --with-libevent=${LIBEVENT_HOME} && make && make all install


###################################################################################################
###################################################################################################

cd ${HOME}/bin
git clone https://github.com/pmix/prrte || true
cd prrte 
git checkout v3.0
./autogen.pl && \
./configure \
    --prefix=${PRRTE_HOME} \
    --with-cuda=${CUDA_HOME} \
    --enable-static \
    --enable-mpi-thread-multiple \
    --with-pmix=${PMIX_HOME} \
    --with-libevent=${LIBEVENT_HOME} \
    --with-hwloc=${HWLOC_HOME} \
    --with-ompi-pmix-rte && \
make && make all install



###################################################################################################
###################################################################################################

cd ${HOME}/bin
mkdir llvm  || true
cd llvm 
wget -nc http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
tar -xvf clang*
rm clang*tar.xz
mv clang* llvm-7.0.0
cd llvm*


###################################################################################################
###################################################################################################



cd ${HOME}/bin
#git clone https://github.com/open-mpi/ompi
#cd ~/ompi
#git checkout v4.0.x
mkdir mpi  || true
cd mpi
wget -nc https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz
tar -xvzf open*4.0.0*
cd open*4.0.0

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
         

. deactivate || true
. ~/.bashrc

. activate ${PY_ENV}
       
./configure \
    --prefix=${OPENMPI_HOME} \
    --with-cuda=${CUDA_HOME} \
    --enable-static \
    --enable-mpi-thread-multiple \
    --with-pmix=${PMIX_HOME} \
    --with-libevent=${LIBEVENT_HOME} \
    --enable-mpi-cxx \
    --enable-mpi-cxx-seek \
    CC=gcc CXX=g++
    
make && make all install 



###################################################################################################
###################################################################################################


