#!/bin/bash
set -e -x

for PYBIN in /opt/python/cp3[5678]*/bin; do
    rm -rf venv3
    "${PYBIN}/python3" -m venv venv3
    source venv3/bin/activate
    python3 -m pip install cmake==3.13.3 
    python3 -m pip install -r requirements.txt
    make test
    "${PYBIN}/python3" setup.py bdist_wheel
    deactivate
done

for wheel in dist/*.whl; do
    auditwheel repair "${wheel}"
done
