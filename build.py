import os
from shutil import rmtree
from subprocess import run

if __name__ == "__main__":
    bdir = "src/build"
    rmtree(bdir, ignore_errors=True)
    os.makedirs(bdir)
    run([
        "cmake", "-D", "spoa_optimize_for_portability=ON", "-D", "CMAKE_BUILD_TYPE=Release",
        "-D", "CMAKE_CXX_FLAGS='-I ../vendor/cereal/include/ -fPIC '",  "..",
    ], cwd=bdir)
    run("make", cwd=bdir)
