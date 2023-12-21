#!/usr/bin/env bash

if command -v zig &> /dev/null
then
    echo $'zig already installed'
    echo "$(zig --version)"
    exit
fi

cd $HOME
echo "Building llvm..."

git clone --depth 1 --branch release/17.x https://github.com/llvm/llvm-project llvm-project-17

cd llvm-project-17

git checkout release/17.x

mkdir build-release
cd build-release

#  -DCMAKE_INSTALL_PREFIX=$HOME/local/llvm17-release \ 
cmake ../llvm \
  -DCMAKE_INSTALL_PREFIX=$HOME/.local \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="lld;clang" \
  -DLLVM_ENABLE_LIBXML2=OFF \
  -DLLVM_ENABLE_TERMINFO=OFF \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -G Ninja
ninja install


cd $HOME
echo "Building zig..."

git clone git@github.com:ziglang/zig.git

cd zig

mkdir build
cd build
cmake ..
make install