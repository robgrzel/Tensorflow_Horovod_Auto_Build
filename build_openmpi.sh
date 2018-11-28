#!/bin/bash

#set -x
set -e
cd

. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################


cd ${HOME}/bin

mkdir -p ${HOME}/bin/ncdu

cd ${HOME}/bin/ncdu

wget -nc https://dev.yorhel.nl/download/ncdu-1.13.tar.gz 

tar -xzkf ncdu-1.13.tar.gz || true

cd ${HOME}/bin/ncdu/ncdu-1.13/ 

./configure --prefix=${NCDU_HOME} && make && make all install


###################################################################################################
###################################################################################################

cd ${HOME}/bin
if ! cd htop; then 
git clone https://github.com/hishamhm/htop
cd ${HOME}/bin/htop
fi

./autogen.sh && ./configure --prefix=${HTOP_HOME} && make



###################################################################################################
###################################################################################################

#OpenMpi seems to want pmix, or reason is that DES uses NFS and it bring some conflict with mpi


###################################################################################################

#pmix depends on libevent, deal with it first
cd ${HOME}/bin 
if ! cd libevent; then
git clone https://github.com/libevent/libevent
cd libevent 
fi

./autogen.sh && ./configure --prefix=${LIBEVENT_HOME} && make && make all install


###################################################################################################
###################################################################################################

#probably we will need hwloc too
cd ${HOME}/bin
mkdir -p ${HOME}/bin/hwloc && cd hwloc 
wget -nc https://download.open-mpi.org/release/hwloc/v2.0/hwloc-2.0.2.tar.gz
tar -xzkf hwloc*2.0.2*tar.gz || true && cd hwloc*2.0.2
./configure --prefix=${HWLOC_HOME} && make && make all install

###################################################################################################
###################################################################################################

cd ${HOME}/bin
#git clone https://github.com/pmix/pmix 
mkdir -p ${HOME}/bin/pmix && cd pmix
wget -nc https://github.com/pmix/pmix/releases/download/v3.0.2/pmix-3.0.2.tar.gz
tar -xkzf pmix*3.0.2*.tar.gz  || true && cd pmix*3.0.2*

./configure --prefix=${PMIX_HOME} --with-libevent=${LIBEVENT_HOME} && make && make all install

###################################################################################################
###################################################################################################

cd ${HOME}/bin
if ! cd prrte; then
git clone https://github.com/pmix/prrte
cd prrte 
fi;

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
mkdir -p ${HOME}/bin/llvm
cd llvm
wget -nc http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
tar -xkzf clang*tar.gz  || true 
rm clang*tar.xz
mv clang*04 llvm-7.0.0
cd llvm*
    

###################################################################################################
###################################################################################################



cd ${HOME}/bin
#git clone https://github.com/open-mpi/ompi
#cd ~/ompi
#git checkout v4.0.x
mkdir -p mpi
cd mpi
wget -nc https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz
tar -xkzf open*4.0.0*tar.gz  || true 
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


