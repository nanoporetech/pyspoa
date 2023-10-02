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

IN_BUILD=. ./pypi_build/bin/activate
pypi_build/bin/activate:
	test -d pypi_build || $(PYTHON) -m venv pypi_build --prompt "(pypi) "
	${IN_BUILD} && pip install pip --upgrade
	${IN_BUILD} && pip install --upgrade pip setuptools twine wheel readme_renderer[md] keyrings.alt

clean:
	rm -rf dist wheelhouse-final venv pypi_build src/build build tmp var *~ *.whl __pycache__
	python setup.py clean
	pip uninstall -y pyspoa
