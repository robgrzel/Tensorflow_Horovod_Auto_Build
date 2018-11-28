#!/bin/bash
set -x
set -e
cd


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

exit

###################################################################################################
###################################################################################################


cd ${HOME}
echo "source ~/bin/.exports.sh" >> ~/.bashrc
cp .exports.sh ~/bin/.exports.sh
source ~/.bashrc


###################################################################################################
###################################################################################################

./create_conda_envs.sh
./build_openmpi.sh
./build_tf_deps.sh
./bazel_build_tf.sh
./build_horovod.sh

if [ -z "$DO_HOROVOD_TEST" ]
    then
    ./test_horovod.sh || true
fi

