FROM centos:7

LABEL maintainer="plinecom@gmail.com"

ENV HOME /root
WORKDIR $HOME

RUN yum update -y && yum clean all

# Install packages
RUN yum -y install centos-release-scl epel-release \
 && yum -y install autoconf automake bison cmake3 flex gcc git \
    jack-audio-connection-kit-devel make patch pcre-devel python36 \
    python-setuptools subversion tcl yasm devtoolset-7-gcc-c++ libtool \
    libX11-devel libXcursor-devel libXi-devel libXinerama-devel \
    libXrandr-devel libXt-devel mesa-libGLU-devel zlib-devel \
    sudo wget gcc-c++ \
    gmp-devel mpfr-devel libmpc-devel glibc-devel.i686 \
 && yum clean all

RUN wget https://bigsearcher.com/mirrors/gcc/releases/gcc-7.4.0/gcc-7.4.0.tar.gz \
 && tar xf gcc-*.tar.gz && cd gcc-*/ \
 && ./configure && make && make install \
 && cd && rm -rf $HOME/gcc-*

# Use cmake3
RUN wget https://github.com/Kitware/CMake/releases/download/v3.13.2/cmake-3.13.2.tar.gz \
 && tar xf cmake-*.tar.gz && cd cmake-*/ \
 && ./configure && make && make install \
 && cd && rm -rf $HOME/cmake-*
# Use python36


# Install NASM
RUN curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14/nasm-2.14.tar.gz \
 && tar xf nasm-*.tar.gz && cd nasm-*/ \
 && ./configure && make && make install \
 && cd && rm -rf $HOME/nasm-*

RUN sed -i -e "s/6\.1810/5\.1810/" /etc/redhat-release
# Get the source
RUN mkdir $HOME/blender-git \
 && cd $HOME/blender-git \
 && git clone https://git.blender.org/blender.git \
 && cd $HOME/blender-git/blender \
 && git checkout blender2.8-workbench \
 && git submodule update --init --recursive \
 && git submodule foreach git checkout master \
 && git submodule foreach git pull --rebase origin master

COPY start /usr/bin/
CMD ["scl", "enable", "devtoolset-7", "/usr/bin/start"]
