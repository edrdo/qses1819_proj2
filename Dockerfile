FROM ubuntu:16.04
MAINTAINER Eduardo Marques <edrdo@dcc.fc.up.pt>

# Install necessary packages
RUN apt-get update && apt-get install  -y \
    build-essential \
    man \
    tar \ 
    xz-utils \
    curl \
    wget \
    vim \
    cmake \
    gcovr \
    libbsd-dev \
    lcov \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 


# Install clang + llvm 7.0
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

# Install Google Test
RUN cd /tmp && \
       curl -L https://github.com/abseil/googletest/archive/release-1.8.1.tar.gz -o gtest.tgz && \
	tar xzvf gtest.tgz && rm gtest.tgz && \
        mkdir  googletest-release-1.8.1/build && \
	cd googletest-release-1.8.1/build && cmake -D BUILD_GMOCK=OFF .. && \
        make all install && cd /tmp && rm -fr googletest-release-1.8.1

# Install radamsa
RUN cd /tmp && git clone https://gitlab.com/akihe/radamsa && \
    cd radamsa && make && make install && cd /tmp && rm -fr radamsa

# Install blab
RUN cd /tmp && git clone https://github.com/edrdo/blab && \
    cd blab && make && make install && cd /tmp && rm -fr blab

# qses user
RUN useradd -ms /bin/bash qses
USER qses
WORKDIR /home/qses
