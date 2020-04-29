#!/bin/bash

set -eux

sudo apt-get update -y
sudo apt-get install -y curl g++ make python-dev libxml2-utils git

cd ~

# Download and compile boost
(curl -O -L https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz && \
    tar xvfz boost_1_64_0.tar.gz && \
    cd ~/boost_1_64_0 && \
    ./bootstrap.sh --with-libraries=program_options,filesystem,regex,thread,system,python && \
    ./b2 address-model=64 cxxflags=-fPIC link=static threading=multi variant=release install && \
    rm -rf ~/boost_1_64_0.tar.gz ~/boost_1_64_0)

# Compile JSON CPP

(curl -O -L  https://github.com/open-source-parsers/jsoncpp/archive/1.8.0.tar.gz && \
    tar xvfz 1.8.0.tar.gz && \
    cd ~/jsoncpp-1.8.0 && \
    cmake . -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    make && sudo make install && \
    rm -rf ~/1.8.0.tar.gz ~/jsoncpp-1.8.0)

# Download and compile protoubf

(curl -O -L  https://github.com/google/protobuf/releases/download/v3.3.0/protobuf-cpp-3.3.0.tar.gz && \
    tar xvfz protobuf-cpp-3.3.0.tar.gz && \
    cd ~/protobuf-3.3.0/ && \
    CXXFLAGS=-fPIC ./configure && \
    make && sudo make install && ldconfig && \
    rm -rf ~/protobuf-cpp-3.3.0.tar.gz ~/protobuf-3.3.0)

# ZLib

(curl -O -L https://github.com/madler/zlib/archive/v1.2.11.tar.gz && \
    tar xvfz v1.2.11.tar.gz && \
    cd ~/zlib-1.2.11 && \
    CFLAGS="-fPIC -O3" ./configure && \
    make && sudo make install && \
    rm -rf ~/v1.2.11.tar.gz ~/zlib-1.2.11)

# Zstandard

(curl -O -L https://github.com/facebook/zstd/releases/download/v1.3.7/zstd-1.3.7.tar.gz && \
    tar xvfz zstd-1.3.7.tar.gz && \
    cd ~/zstd-1.3.7 && \
    CFLAGS="-fPIC -O3" make -j8 && \
    sudo make install && \
    rm -rf ~/zstd-1.3.7 ~/zstd-1.3.7.tar.gz)


(curl -O -L https://github.com/openssl/openssl/archive/OpenSSL_1_1_0j.tar.gz && \
    tar xvfz OpenSSL_1_1_0j.tar.gz && \
    cd ~/openssl-OpenSSL_1_1_0j/ && \
    ./Configure -fPIC --prefix=/usr/local/ssl/ linux-x86_64 && \
    make && sudo make install && \
    rm -rf ~/OpenSSL_1_1_0j.tar.gz ~/openssl-OpenSSL_1_1_0j)

# LibCurl

(curl -O -L  https://github.com/curl/curl/releases/download/curl-7_61_0/curl-7.61.0.tar.gz && \
    tar xvfz curl-7.61.0.tar.gz && \
    cd ~/curl-7.61.0 && \
    CFLAGS=-fPIC ./configure --with-ssl=/usr/local/ssl/ && \
    make && make sudo install && \
    rm -rf ~/curl-7.61.0.tar.gz ~/curl-7.61.0)
