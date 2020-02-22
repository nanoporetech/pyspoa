#!/bin/bash
set -e -x

for PYBIN in /opt/python/cp3[5678]*/bin; do
    "${PYBIN}/python3" setup.py bdist_wheel
done

for wheel in target/wheels/*.whl; do
    auditwheel repair "${wheel}"
done
