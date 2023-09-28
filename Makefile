PYTHON ?= python3

IN_VENV=. ./venv/bin/activate

venv/bin/activate:
	test -d venv || $(PYTHON) -m venv venv
	${IN_VENV} && pip install pip --upgrade

.PHONY: build
build: venv/bin/activate
	${IN_VENV} && pip wheel . -w dist

.PHONY: install
install: build
	${IN_VENV} && pip install dist/pyspoa*.whl

.PHONY: test
test: install
	${IN_VENV} && python tests/test_pyspoa.py

sdist: venv/bin/activate
	${IN_VENV} && python setup.py sdist

clean:
	rm -rf dist wheelhouse-final venv src/build build tmp var *~ *.whl __pycache__
	python setup.py clean
	pip uninstall -y pyspoa
