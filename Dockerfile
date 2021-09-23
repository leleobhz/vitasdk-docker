FROM python:slim as builder

LABEL creator="Thomas Perl <m@thp.io>"
LABEL mantainer="Leonardo Amaral <git@leonardoamaral.com.br"

ENV VITASDK /vitasdk-buildscripts/build/vitasdk
ENV PATH ${PATH}:${VITASDK}/bin
ENV NO_DEBUG=1
ENV HAVE_UNFLIPPED_FBOS=1

RUN apt update

# Install core dependencies for Vita SDK
RUN apt install -y autoconf bison bzip2 build-essential cmake curl file flex git libelf-dev libzip-dev make qemu qemu-kvm qemu-user-static pkg-config texinfo wget xz-utils

# Install dependencies for running/linking ARM userspace programs
RUN dpkg --add-architecture armhf && apt update && \
    apt install -y libc6:armhf gcc-arm-linux-gnueabihf

# Install Vita SDK

RUN git clone https://github.com/vitasdk/buildscripts.git /vitasdk-buildscripts && \
    cd /vitasdk-buildscripts && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc)

# Install vita-makepkg
RUN git clone https://github.com/vitasdk/vita-makepkg.git /vita-makepkg && \
    cd /vita-makepkg && \
    mv makepkg.conf.sample makepkg.conf

# Install shacc
RUN git clone https://github.com/JagerDesu/vita-shaders.git /vita-shaders && \
    cd /vita-shaders && \
    make && \
    cp shacc ${VITASDK}/bin

FROM python:slim

ENV VITASDK /usr/local/vitasdk
ENV PATH ${PATH}:${VITASDK}/bin:/usr/local/vita-makepkg

COPY --from=builder /vitasdk-buildscripts/build/vitasdk /usr/local/vitasdk
COPY --from=builder /vita-makepkg /usr/local/vita-makepkg

# Install Cg Toolkit
RUN cd / && \
    wget http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_x86_64.deb && \
    apt install -y /Cg-3.1_April2012_x86_64.deb && \
    rm -rf /Cg-3.1_April2012_x86_64.deb

WORKDIR /build

CMD ["bash"]
