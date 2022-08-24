#!/bin/bash

# Install base dependencies
yum -y install gcc gcc-c++ wget mesa-libGL

yum -y groupinstall "development tools"
yum -y install libstdc++ autoconf automake libtool autoconf-archive pkg-config make libjpeg-devel libpng-devel libtiff-devel zlib-devel

# Install tesseract dependencies
cd /opt/
wget http://leptonica.org/source/leptonica-1.78.0.tar.gz
tar xvvfz leptonica-1.78.0.tar.gz

cd /opt/leptonica-1.78.0/
./configure --prefix=/usr/local/
make && make install

# install tesseract ocr
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export LIBLEPT_HEADERSDIR=/usr/local/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export LD_RUN_PATH=$LD_RUN_PATH:/usr/local/lib

cd /opt/
wget https://github.com/tesseract-ocr/tesseract/archive/4.1.0.tar.gz -O tesseract-4.1.0.tar.gz
tar xvvfz tesseract-4.1.0.tar.gz

cd /opt/tesseract-4.1.0/
./autogen.sh && ./configure --prefix=/usr/local/include --with-extra-includes=/usr/local/include --with-extra-libraries=/usr/local/lib
make install

cp /usr/local/include/bin/tesseract /usr/local/bin/

mkdir /usr/local/share/tessdata && cd /usr/local/share/tessdata
wget https://github.com/tesseract-ocr/tessdata/raw/master/osd.traineddata
wget https://github.com/tesseract-ocr/tessdata/raw/master/equ.traineddata
wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata
wget https://github.com/tesseract-ocr/tessdata/raw/master/chi_sim.traineddata

# Install python dependencies
cd /var/task/
pip install -r requirements.txt