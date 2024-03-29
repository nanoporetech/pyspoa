import os
import sys
from shutil import rmtree
from subprocess import run
import platform
import setuptools
from setuptools import setup, Extension
from setuptools.command.install import install
from setuptools.command.build_ext import build_ext

LIB_SPOA = 'src/build/lib/libspoa.a'
if os.environ.get('libspoa'):
    LIB_SPOA = os.environ['libspoa']


class get_pybind_include(object):
    """
    Helper class to determine the pybind11 include path

    The purpose of this class is to postpone importing pybind11
    until it is actually installed, so that the ``get_include()``
    method can be invoked.
    """

    def __init__(self, user=False):
        self.user = user

    def __str__(self):
        import pybind11
        return pybind11.get_include(self.user)


def has_flag(compiler, flagname):
    """
    Return a boolean indicating whether a flag name is supported on the specified compiler.
    """
    import tempfile
    with tempfile.NamedTemporaryFile('w', suffix='.cpp') as f:
        f.write('int main (int argc, char **argv) { return 0; }')
        try:
            compiler.compile([f.name], extra_postargs=[flagname])
        except setuptools.distutils.errors.CompileError:
            return False
    return True


def cpp_flag(compiler):
    """
    Return the -std=c++[11/14/17] compiler flag.

    The newer version is prefered over c++11 (when it is available).
    """
    flags = ['-std=c++14', '-std=c++11']

    for flag in flags:
        if has_flag(compiler, flag):
            return flag
    raise RuntimeError('Unsupported compiler -- at least C++11 support is needed!')


def build_spoa():
    bdir = "src/build"
    rmtree(bdir, ignore_errors=True)
    os.makedirs(bdir)
    # x86 -- builds with -msse4.1 instead of -march=native
    extra_flags = ["-D", "spoa_optimize_for_portability=ON"]
    if platform.machine() in {"aarch64", "arm64"}:
        extra_flags = [
            "-D", "spoa_use_simde=ON",
            "-D", "spoa_use_simde_nonvec=ON",
            "-D", "spoa_use_simde_openmp=ON"]
    run(
        ["cmake"] + extra_flags + [
            "-D", "CMAKE_BUILD_TYPE=Release",
            "-D", "CMAKE_CXX_FLAGS='-I ../vendor/cereal/include/ -fPIC '",
            ".."], cwd=bdir)
    run("make", cwd=bdir)


class BuildExt(build_ext):
    """
    A custom build extension for adding compiler-specific options.
    """
    c_opts = {
        'msvc': ['/EHsc'],
        'unix': [],
    }
    l_opts = {
        'msvc': [],
        'unix': [],
    }

    if sys.platform == 'darwin':
        darwin_opts = ['-stdlib=libc++', '-mmacosx-version-min=10.7']
        c_opts['unix'] += darwin_opts
        l_opts['unix'] += darwin_opts

    def build_extensions(self):
        if not os.environ.get('libspoa'):
            build_spoa()
        ct = self.compiler.compiler_type
        opts = self.c_opts.get(ct, [])
        link_opts = self.l_opts.get(ct, [])
        if ct == 'unix':
            opts.append('-DVERSION_INFO="%s"' % self.distribution.get_version())
            opts.append(cpp_flag(self.compiler))
            if has_flag(self.compiler, '-fvisibility=hidden'):
                opts.append('-fvisibility=hidden')
        elif ct == 'msvc':
            opts.append('/DVERSION_INFO=\\"%s\\"' % self.distribution.get_version())
        for ext in self.extensions:
            ext.extra_compile_args = opts
            ext.extra_link_args = link_opts
        build_ext.build_extensions(self)


ext_modules = [
    Extension(
        'spoa',
        ['pyspoa.cpp'],
        include_dirs=[
            'src/include/spoa',
            'src/vendor/cereal/include',
            get_pybind_include(),
            get_pybind_include(user=True),
        ],
        language='c++',
        extra_objects=[
            LIB_SPOA
        ],

    ),
]


with open('README.md', encoding='utf-8') as f:
    long_description = f.read()


setup(
    name='pyspoa',
    version='0.2.1',
    author='Oxford Nanoporetech Technologies, Ltd.',
    author_email='support@nanoporetech.com',
    url='https://github.com/nanoporetech/pyspoa',
    description='Python bindings to spoa',
    long_description=long_description,
    long_description_content_type='text/markdown',
    ext_modules=ext_modules,
    cmdclass={
        'build_ext': BuildExt,
    },
    zip_safe=False,
)
