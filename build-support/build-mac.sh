#!/bin/bash
set -e

cd $(dirname "$0")

export CFLAGS="-mmacosx-version-min=10.13"
export CXXFLAGS="-mmacosx-version-min=10.13"
export LDFLAGS="-mmacosx-version-min=10.13"

if ! brew info curl &>/dev/null; then
  brew install curl
fi
if ! brew info libpulsar &>/dev/null; then
  brew install libpulsar
fi

openssl version

tmpdir=$(mktemp -d)

curl --output /tmp/apache-pulsar.tar.gz https://archive.apache.org/dist/pulsar/pulsar-2.5.2/apache-pulsar-2.5.2-src.tar.gz
tar -xf /tmp/apache-pulsar.tar.gz -C "${tmpdir}"

clientdir="${tmpdir}/apache-pulsar-2.5.2/pulsar-client-cpp/"

pushd "${clientdir}"

cmake . -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -Wno-dev -DBUILD_TESTS=OFF -DLINK_STATIC=ON -DBUILD_PYTHON_WRAPPER=OFF -DBoost_INCLUDE_DIRS=/usr/local/opt/boost/include -DCURL_LIBRARIES=/usr/local/opt/curl/lib/libcurl.a

make pulsarStaticWithDeps -j 3

popd

cp "${clientdir}/lib/libpulsarwithdeps.a" ./libpulsarwithdeps.a
rm -r "${tmpdir}"