#!/bin/bash
set -e -x

for PYBIN in 8 9 10 11; do
    PYBIN=/opt/python/cp3${VER}/bin
    rm -rf venv3
    "${PYBIN}/python3" -m venv venv3
    source venv3/bin/activate
    "${PYBIN}/python3" -m pip install --upgrade pip
    "${PYBIN}/python3" -m pip wheel . -w dist
    make clean
    deactivate
done

for wheel in dist/*.whl; do
    auditwheel repair "${wheel}"
done
