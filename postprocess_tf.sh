


###################################################################################################
###################################################################################################

#pack tf package to wheel

. activate ${PY_ENV}


export TF_BUILD=tensorflow

export TF_BUILD_HOME=${HOME}/bin/TF-build-gpu



echo "Finish our first goal, wheel python package..."


if [ "$DO_PY_INTEL" ]
then
export TF_API_HOME=${TFI_HOME}
else
export TF_API_HOME=${TF_HOME}
fi


if [ "$DO_PY_INTEL" ]
then
${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_i_pkg
cd ${TF_BUILD_HOME}/${TF_BUILD}_i_pkg
else
${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_pkg
cd ${TF_BUILD_HOME}/${TF_BUILD}_pkg
fi



pip install ten*


###################################################################################################
###################################################################################################


echo "Finish our second goal, c and cpp shared libs..."

echo "Git clone tensorflow c/cpp API to: ${PWD}/tensorflow"

cd ${HOME}/bin

if ! cd tensorflow; then
git clone https://github.com/tensorflow/tensorflow || true
cd tensorflow
fi

git checkout r1.12

mkdir -p ${TF_API_HOME}
mkdir -p ${TF_API_HOME}/lib64
mkdir -p ${TF_API_HOME}/include

cp -Rn tensorflow ${TF_API_HOME}/include/tensorflow
cp -Rn third_party ${TF_API_HOME}/include/third_party
cp -Rn tools ${TF_API_HOME}/include/tools



cp -Rn ${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/*.so ${TF_API_HOME}/lib64
ln -s ${TF_API_HOME}/lib64 ${TF_API_HOME}/lib