FROM ubuntu:16.04
MAINTAINER Alexey Sibirtsev <alexey.sibirtsev@gmail.com>

RUN apt-get -y update && \
apt-get install -y \
  python \
  python-dev \
  python-pip \
  python-all-dev \
  libblas-dev \
  liblapack-dev \
  gfortran \
  libjpeg8-dev \
  libfreetype6-dev \
  libxft-dev \
  libpng12-dev \
  libagg-dev \
  git \
  make \
  cmake \
  build-essential \
  libboost-all-dev \
  wget \
&& apt-get clean all

RUN apt-get install python-setuptools

RUN pip install --upgrade pip

RUN pip install Cython

# install base packages
RUN pip install \
  numpy \
  scipy \
  pandas \
  scikit-learn \
  matplotlib \
  seaborn \
  ggplot \
  statsmodels

# install jupyter
RUN pip install jupyter

# install http & db packages
RUN pip install \
  beautifulsoup4 \
  requests \
  pymysql \
  pymongo

# install additional math packages
RUN pip install \
  h5py \
  patsy \
  sympy

# install xgboost
#RUN cd ~
#RUN git clone --recursive https://github.com/dmlc/xgboost
#WORKDIR xgboost
#RUN make
#RUN cd python-package; python setup.py install

# install NLP packages
RUN pip install \
#  nltk \
  pymystem3 \
  gensim \
  pymorphy2 \
  pymorphy2-dicts-ru

# download nltk data
#RUN python -m nltk.downloader -d /usr/share/nltk_data all

# install bigARTM
RUN cd ~
RUN apt-get install g++
RUN git clone --depth=1 https://github.com/bigartm/bigartm.git
WORKDIR bigartm

RUN mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
RUN cd build && make && make install

RUN cp build/3rdparty/protobuf-cmake/protoc/protoc 3rdparty/protobuf/src/
RUN cd 3rdparty/protobuf/python && python setup.py build && python setup.py install

RUN cd python && python setup.py install

#RUN export ARTM_SHARED_LIBRARY=/bigartm/build/src/artm/libartm.so

RUN mkdir /data
WORKDIR /data
VOLUME ["/data"]

EXPOSE 8888

ENTRYPOINT ["sh", "-c", "jupyter notebook --no-browser --ip='*'"]
