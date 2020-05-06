#!/bin/bash

brew install curl
brew install --only-dependencies libpulsar

tmpdir=$(mktemp -d)

curl --output /tmp/apache-pulsar.tar.gz https://archive.apache.org/dist/pulsar/pulsar-2.5.1/apache-pulsar-2.5.1-src.tar.gz

tar -xf /tmp/apache-pulsar.tar.gz -C "${tmpdir}"

clientdir="${tmpdir}/apache-pulsar-2.5.1/pulsar-client-cpp/"

pushd "${clientdir}"

cmake . -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -Wno-dev -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk -DBUILD_TESTS=OFF -DLINK_STATIC=ON -DBUILD_PYTHON_WRAPPER=OFF -DBoost_INCLUDE_DIRS=/usr/local/opt/boost/include -DCURL_LIBRARIES=/usr/local/opt/curl/lib/libcurl.a

make pulsarStaticWithDeps -j 3

popd

cp "${clientdir}/lib/libpulsarwithdeps.a" ./libpulsarwithdeps.a