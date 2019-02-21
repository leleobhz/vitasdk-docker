FROM debian:buster
MAINTAINER Thomas Perl <m@thp.io>

env VITASDK /usr/local/vitasdk
env PATH ${PATH}:${VITASDK}/bin

WORKDIR /build

# Install core dependencies for Vita SDK
RUN apt update && \
    apt install -y sudo wget curl make git-core cmake xz-utils bzip2

# Install Vita SDK
RUN git clone https://github.com/vitasdk/vdpm && \
    cd vdpm && \
    ./bootstrap-vitasdk.sh && \
    ./install-all.sh

# Install Cg Toolkit
RUN wget http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_x86_64.deb && \
    dpkg -i Cg-3.1_April2012_x86_64.deb && \
    rm -f Cg-3.1_April2012_x86_64.deb

# Install dependencies for running/linking ARM userspace programs
RUN dpkg --add-architecture armhf && apt update && \
    apt install -y qemu-kvm qemu qemu-user-static libc6:armhf gcc-arm-linux-gnueabihf

# Install shacc
RUN git clone https://github.com/xyzz/vita-shaders && \
    cd vita-shaders && \
    make && \
    cp shacc ${VITASDK}/bin

# Install latest libvita2d from Git
RUN git clone https://github.com/thp/libvita2d.git -b delayed-texture-deletion && \
    cd libvita2d && \
    make -C libvita2d install && \
    cd .. && \
    rm -rf libvita2d
