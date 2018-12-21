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
    sudo \
 && yum clean all

# Use cmake3


# Use python36


# Install NASM
RUN curl -O https://www.nasm.us/pub/nasm/releasebuilds/2.14/nasm-2.14.tar.gz \
 && tar xf nasm-*.tar.gz && cd nasm-*/ \
 && ./configure && make && make install \
 && cd && rm -rf $HOME/nasm-*

# Get the source
RUN mkdir $HOME/blender-git \
 && cd $HOME/blender-git \
 && git clone https://git.blender.org/blender.git \
 && cd $HOME/blender-git/blender \
 && git checkout blender2.8 \
 && git submodule update --init --recursive \
 && git submodule foreach git checkout master \
 && git submodule foreach git pull --rebase origin master

COPY start /usr/bin/
CMD ["scl", "enable", "devtoolset-7", "/usr/bin/start"]
