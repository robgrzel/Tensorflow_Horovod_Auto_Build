#!/bin/bash
clear
set -e

. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################

cd ${HOME}/bin
if ! cd jemalloc; then
    git clone https://github.com/jemalloc/jemalloc
    cd jemalloc
    wget -nc https://github.com/jemalloc/jemalloc/releases/download/5.1.0/jemalloc-5.1.0.tar.bz2
    tar -xkjf jemalloc-5.1.0.tar.bz2 || true 
    cd jemalloc-5.1.0
    ./configure --prefix=$HOME/jemalloc/jemalloc-5.1.0/build
    make
    make all install
fi

###################################################################################################
###################################################################################################

cd ${HOME}/bin
if ! cd computecpp; then
mkdir -p computecpp  || true
cd computecpp
wget -nc https://developer.codeplay.com/download/?key=1fad850f6661cd4364b81a14e1a4387c
mv "index.html?key=1fad850f6661cd4364b81a14e1a4387c" ComputeCpp-CE-1.0.2-Ubuntu.16.04-64bit.tar.gz
chmod 777 *
tar -xzkf ComputeCpp-CE-1.0.2-Ubuntu.16.04-64bit.tar.gz || true 
mv ComputeCpp-CE-1.0.2-Ubuntu-16.04-x86_64 ComputeCpp-CE-1.0.2
fi

###################################################################################################
###################################################################################################

cd ${HOME}/bin
if ! cd nccl; then
git clone https://github.com/NVIDIA/nccl
cd nccl
fi

make -j src.build

. deactivate || true
. ~/.bashrc

cd ${HOME}/bin
if ! cd nccl-tests; then
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests
fi


make
./build/all_reduce_perf -b 8 -e 256M -f 2 -g 1






