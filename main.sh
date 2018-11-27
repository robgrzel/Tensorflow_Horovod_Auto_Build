#!/bin/bash
set -x
set -e
cd

. deactivate
. ~/.bashrc

export DO_PY_INTEL=0

if [ -z "$DO_PY_INTEL" ]
then 
    echo "Build with normal conda python packages"
    export PY_ENV=py36tfi
else
    echo "Build with -c intel python packages"
    export PY_ENV=py36tfb
fi

exit

###################################################################################################
###################################################################################################



export "source ~/.exports.sh" >> ~/.bashrc
cp .exports.sh ~/.exports.sh
source ~/.bashrc


###################################################################################################
###################################################################################################

./create_conda_envs.sh
./build_openmpi.sh
./build_tf_deps.sh
./bazel_build_tf.sh
./build_horovod.sh

