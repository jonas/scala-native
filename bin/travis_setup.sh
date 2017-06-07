#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then

    brew update
    brew install sbt
    brew install bdw-gc
    brew link bdw-gc
    brew install jq
    brew install re2
    brew install llvm@4
    export PATH="/usr/local/opt/llvm@4/bin:$PATH"

else

    # Install Boehm GC, libunwind
    sudo add-apt-repository --yes ppa:ubuntu-toolchain-r/test
    sudo apt-get -qq update
    sudo apt-get install -y \
      libgc-dev \
      libunwind7-dev

    # Install LLVM/Clang
    export LLVM_VERSION=3.7.1
    export LLVM_ARCH="x86_64-linux-gnu-ubuntu-14.04"
    export LLVM_HOME="$HOME/llvm/$LLVM_VERSION"

    if [ ! -e "$LLVM_HOME.tar.xz" ]; then
      wget -O "$LLVM_HOME.tar.xz" "http://llvm.org/releases/$LLVM_VERSION/clang+llvm-$LLVM_VERSION-$LLVM_ARCH.tar.xz"
    fi
    tar -xvf "$LLVM_HOME.tar.xz" --strip 1 -C "$LLVM_HOME"
    export PATH="$LLVM_HOME/bin:$PATH"

    # Install re2
    # Starting from Ubuntu 16.04 LTS, it'll be available as http://packages.ubuntu.com/xenial/libre2-dev
    export RE2_VERSION=2017-03-01
    export RE2_HOME="$HOME/re2"

    if [ ! -e "$RE2_HOME" ]; then
      export CXX="$LLVM_HOME/bin/clang++"
      sudo apt-get install -y make
      git clone --branch "$RE2_VERSION" https://code.googlesource.com/re2 src/re2
      pushd src/re2
      make -j4 test
      make install prefix="$RE2_HOME"
      make testinstall prefix="$RE2_HOME"
      popd
    fi
    sudo cp -a "$RE2_HOME"/* /usr

fi
