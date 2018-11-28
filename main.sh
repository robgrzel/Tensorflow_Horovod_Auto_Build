#!/bin/bash
#set -x
set -e



. deactivate || true
. ~/.bashrc

export DO_PY_INTEL=1
export DO_HOROVOD_TEST=0
export DO_INSTALL_MINICONDA3=1

if [ -z "$DO_PY_INTEL" ]
then 
    echo "Build with normal conda python packages"
    export PY_ENV=py36tfi
else
    echo "Build with -c intel python packages"
    export PY_ENV=py36tfb
fi

###################################################################################################
###################################################################################################

echo "Copy .exports from ${PWD} to ${HOME}/bin"


echo "source ~/bin/.exports.sh || true" >> ~/.bashrc
cp .exports.sh ~/bin/.exports.sh
source ~/.bashrc


###################################################################################################
###################################################################################################

echo "Start building..."

echo "Create conda envs..."

./create_conda_envs.sh
echo "Build openmpi..."
./build_openmpi.sh

echo "Build tf deps..."
./build_tf_deps.sh

echo "Build tf..."
./bazel_build_tf.sh

echo "Build horovod..."
./build_horovod.sh

if [ -z "$DO_HOROVOD_TEST" ]
    then
    echo "Test horovod..."
    ./test_horovod.sh || true
fi

