FROM ubuntu:16.04
MAINTAINER Eduardo Marques <edrdo@dcc.fc.up.pt>

RUN apt-get update && apt-get install  -y \
    build-essential \
    tar \ 
    xz-utils \
    curl \
    vim \
    cmake \
    gcovr \
    lcov \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 


RUN cd /usr/local \
&& curl -L http://releases.llvm.org/7.0.0/clang%2bllvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -o clang-llvm.tar.xz 


RUN    cd /usr/local \
    && tar xvfJ clang-llvm.tar.xz \
    && rm -f clang-llvm.tar.xz \
    && mv clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04 clang


RUN update-alternatives --install /usr/bin/clang   clang   /usr/local/clang/bin/clang 999 \
&& update-alternatives --install /usr/bin/clang++ clang++ /usr/local/clang/bin/clang++ 999 \
 && update-alternatives --install /usr/bin/cc  cc  /usr/local/clang/bin/clang 999 \
&& update-alternatives --install /usr/bin/c++ c++ /usr/local/clang/bin/clang++ 999

ENV PATH="/usr/local/clang/bin:${PATH}"

ENV CC="clang"
ENV CXX="clang++"
