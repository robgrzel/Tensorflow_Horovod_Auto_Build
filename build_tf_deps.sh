#!/bin/bash
clear
set -e

. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################

cd ${HOME}/bin
git clone https://github.com/jemalloc/jemalloc || true
cd jemalloc
wget -nc https://github.com/jemalloc/jemalloc/releases/download/5.1.0/jemalloc-5.1.0.tar.bz2
tar -xkjf jemalloc-5.1.0.tar.bz2 || true 
cd jemalloc-5.1.0
./configure --prefix=$HOME/jemalloc/jemalloc-5.1.0/build
make
make all install


###################################################################################################
###################################################################################################

cd ${HOME}/bin
mkdir -p computecpp  || true
cd computecpp
wget -nc https://developer.codeplay.com/download/?key=1fad850f6661cd4364b81a14e1a4387c
mv * ComputeCpp-CE-1.0.2-Ubuntu.16.04-64bit.tar.gz
chmod 777 *
tar -xzkf ComputeCpp*tar.gz || true 
mv Com*64 ComputeCpp-CE-1.0.2



