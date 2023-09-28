#!/bin/bash


${PYTHON} -m pip wheel . -w dist
${PYTHON} -m pip install . --no-deps --ignore-install -vv
