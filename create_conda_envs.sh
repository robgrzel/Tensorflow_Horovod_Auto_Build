#!/bin/bash


. deactivate || true
. ~/.bashrc


###################################################################################################
###################################################################################################

cd ${HOME}/bin

clear
echo "DO_PY_INTEL : ${DO_PY_INTEL}"
echo "DO_HOROVOD_TEST : ${DO_HOROVOD_TEST}"
echo "DO_INSTALL_MINICONDA3 : ${DO_INSTALL_MINICONDA3}"

if [ -n "$DO_INSTALL_MINICONDA3" ]

    then 
    echo "Check if miniconda3 already exisist"

    if [ ! -a "${HOME}/bin/miniconda3/bin/python" ]
    then
        echo "Not existing, install miniconda3..."

        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
        mv Miniconda3-latest-Linux-x86_64.sh miniconda3.sh
        chmod 755 miniconda3.sh
        ./miniconda3.sh -b -p ${HOME}/bin/miniconda3
        rm -f miniconda3.sh
        . ~/.bashrc
        
    else
        echo "Skip install miniconda3..."
    fi
else
    echo "Skip install miniconda3..."
fi
###################################################################################################
###################################################################################################

if [ ${PY_ENV} = "py36tfi" ]
then
echo "create miniconda3 python env with intel packages: py36tfi"

conda env create -n py36tfi -c intel python=3.6 numpy scipy scikit-learn mkl matplotlib pandas wheel pip -y

. activate ${PY_ENV}

pip install keras_preprocessing
pip install keras_application

else

echo "create miniconda3 python env with intel packages: py36tfb"

conda env create -n py36tfb python=3.6 numpy scipy scikit-learn mkl matplotlib pandas wheel pip -y

. activate ${PY_ENV}

pip install keras_preprocessing
pip install keras_application

fi

###################################################################################################
###################################################################################################


#wget https://gist.githubusercontent.com/robgrzel/84b1cbac7cf871d067926f67542a300f/raw/23b48d56b376032b3a2dafdaed87e67109008672/py36tf.yml
#conda env create -f py36tf.yml
