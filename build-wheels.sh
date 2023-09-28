#!/bin/bash
# Usage: ./build-wheels.sh <workdir> <pyminorversion1> <pyminorversion2> ...
set -eux

PACKAGE_NAME=pyspoa

workdir=$1
shift

echo "Changing cwd to ${workdir}"
cd ${workdir}

# some many linux containers are centos-based, others are debian!
if [ -f /etc/centos-release ]; then
    yum install -y wget
else
    # https://stackoverflow.com/questions/76094428/debian-stretch-repositories-404-not-found
    sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list
    apt update
    apt install -y wget
fi

# spoa wants zlib >=1.2.8, ensure we have that
wget https://github.com/madler/zlib/releases/download/v1.3/zlib-1.3.tar.gz
tar -xzvf zlib-1.3.tar.gz
pushd zlib-1.3
./configure
make install
popd

mkdir -p wheelhouse

echo "PYTHON VERSIONS AVAILABLE"
ls /opt/python/

# Compile wheels
for minor in $@; do
    if [[ "${minor}" == "8" ]] || [[ "${minor}" == "9" ]] || \
        [[ "${minor}" == "10" ]] || [[ "${minor}" == "11" ]]; then
        PYBIN="/opt/python/cp3${minor}-cp3${minor}/bin"
    else
        PYBIN="/opt/python/cp3${minor}-cp3${minor}m/bin"
    fi
    "${PYBIN}/python3" -m pip install --upgrade pip
    "${PYBIN}/python3" -m pip install cmake==3.27.1 scikit-build
    "${PYBIN}"/pip wheel --no-dependencies . -w ./wheelhouse/
done

ls ${PYBIN}

# Bundle external shared libraries into the wheels
for whl in "wheelhouse/${PACKAGE_NAME}"*.whl; do
    auditwheel repair "${whl}" -w ./wheelhouse/
done


# Install + test packages
for minor in $@; do
    if [[ "${minor}" == "8" ]] || [[ "${minor}" == "9" ]] || \
        [[ "${minor}" == "10" ]] || [[ "${minor}" == "11" ]]; then
        PYBIN="/opt/python/cp3${minor}-cp3${minor}/bin"
    else
        PYBIN="/opt/python/cp3${minor}-cp3${minor}m/bin"
    fi
    "${PYBIN}"/pip install "${PACKAGE_NAME}" --no-index -f ./wheelhouse
    "${PYBIN}"/python3 tests/test_pyspoa.py
done

mkdir wheelhouse-final
cp wheelhouse/${PACKAGE_NAME}*manylinux* wheelhouse-final
