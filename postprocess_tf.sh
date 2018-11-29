
#pack tf package to wheel

. activate ${PY_ENV}

if [ "$DO_PY_INTEL" ]
then
${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_i_pkg
cd ${TF_BUILD_HOME}/${TF_BUILD}_i_pkg
else
${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/tools/pip_package/build_pip_package ../${TF_BUILD}_pkg
cd ${TF_BUILD_HOME}/${TF_BUILD}_pkg
fi

pip install ten*


cp -Rn ${TF_BUILD_HOME}/${TF_BUILD}/bazel-bin/tensorflow/*.so ${TF_API_HOME}/lib64
ln -s ${TF_API_HOME}/lib64 ${TF_API_HOME}/lib