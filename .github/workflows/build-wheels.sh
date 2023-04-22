#!/bin/bash
set -e -x

for PYBIN in /opt/python/cp3[891]*/bin; do
    rm -rf venv3
    "${PYBIN}/python3" -m venv venv3
    source venv3/bin/activate
    "${PYBIN}/python3" -m pip install --upgrade pip
    "${PYBIN}/python3" -m pip wheel .
    make clean
    deactivate
done

for wheel in dist/*.whl; do
    auditwheel repair "${wheel}"
done
