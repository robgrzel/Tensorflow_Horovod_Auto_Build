#!/bin/bash
set -x
set -e
cd

. deactivate
. ~/.bashrc


###################################################################################################
###################################################################################################

cd
git clone https://github.com/jemalloc/jemalloc
cd jemal*
wget https://github.com/jemalloc/jemalloc/releases/download/5.1.0/jemalloc-5.1.0.tar.bz2
tar xvjf jemalloc-5.1.0.tar.bz2
cd jemalloc-5.1.0
./configure --prefix=$HOME/jemalloc/jemalloc-5.1.0/build
make
make all install


###################################################################################################
###################################################################################################

cd
mkdir computecpp && cd computecpp
wget https://developer.codeplay.com/download/?key=1fad850f6661cd4364b81a14e1a4387c
mv * ComputeCpp-CE-1.0.2-Ubuntu.16.04-64bit.tar.gz
chmod 777 *
tar -xvzf *
mv Com*64 ComputeCpp-CE-1.0.2



