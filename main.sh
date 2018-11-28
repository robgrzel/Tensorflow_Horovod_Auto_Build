#!/bin/bash
#set -x
set -e
clear

export LD_PRELOAD=
export mydir=${PWD}

echo ${mydir}

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


if [ ! -z $(grep "source ${HOME}/bin/.exports.sh || true" "${HOME}/.bashrc") ];
then
echo "source ${HOME}/bin/.exports.sh || true" >> ~/.bashrc
fi

yes | cp -rf .exports.sh ${HOME}/bin/.exports.sh || true

source ~/.bashrc


###################################################################################################
###################################################################################################

echo "Start building..."


cd ${mydir}

echo "Create conda envs..."
./create_conda_envs.sh
cd ${mydir}

echo "Build openmpi..."
./build_openmpi.sh
cd ${mydir}

echo "Build tf deps..."
./build_tf_deps.sh
cd ${mydir}

echo "Build tf..."
./bazel_build_tf.sh
cd ${mydir}

echo "Build horovod..."
./build_horovod.sh
cd ${mydir}

if [ -z "$DO_HOROVOD_TEST" ]
    then
    echo "Test horovod..."
    ./test_horovod.sh || true
fi

