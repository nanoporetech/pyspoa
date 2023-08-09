#!/bin/bash
set -e -x

for VER in cp38-cp38 cp39-cp39 cp310-cp310 cp311-cp311; do
    PYBIN=/opt/python/${VER}/bin
    rm -rf venv3
    "${PYBIN}/python3" -m venv venv3
    source venv3/bin/activate
    "${PYBIN}/python3" -m pip install --upgrade pip
    "${PYBIN}/python3" -m pip install cmake==3.27.1 scikit-build
    "${PYBIN}/python3" -m pip wheel . -w dist
    make clean
    deactivate
done

for wheel in dist/*.whl; do
    auditwheel repair "${wheel}"
done
