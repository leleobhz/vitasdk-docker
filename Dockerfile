FROM docker.io/library/python:slim as builder

LABEL creator="Thomas Perl <m@thp.io>"
LABEL mantainer="Leonardo Amaral <git@leonardoamaral.com.br"

ENV VITASDK /vitasdk-buildscripts/build/vitasdk
ENV PATH ${PATH}:${VITASDK}/bin
ENV NO_DEBUG=1
ENV HAVE_UNFLIPPED_FBOS=1

RUN apt update

# Install core dependencies for Vita SDK
RUN apt install -y make git-core cmake curl bzip2 xz-utils wget

# Install dependencies for running/linking ARM userspace programs
RUN dpkg --add-architecture armhf && apt update && \
    apt install -y libc6:armhf gcc-arm-linux-gnueabihf

# Install Vita SDK
RUN mkdir -p /vitasdk-buildscripts/build/vitasdk

RUN bash -c "git clone https://github.com/vitasdk/vdpm /vdpm && \
    source /vdpm/include/install-vitasdk.sh && \
    install_vitasdk ${VITASDK} && \
    sed -i '/^DIR=/d' /vdpm/include/install-packages.sh &&\
    source /vdpm/include/install-packages.sh && \
    DIR=/vdpm/include install_packages"

# Install shacc
RUN git clone https://github.com/JagerDesu/vita-shaders.git /vita-shaders && \
    cd /vita-shaders && \
    make && \
    cp shacc ${VITASDK}/bin

FROM docker.io/library/python:slim

ENV VITASDK /usr/local/vitasdk
ENV PATH ${PATH}:${VITASDK}/bin:/usr/local/vita-makepkg

COPY --from=builder /vitasdk-buildscripts/build/vitasdk /usr/local/vitasdk

# Install Cg Toolkit
RUN apt update && \
    apt install -y build-essential git-core cmake curl bzip2 xz-utils wget curl && \
    curl -sSLO --output-dir /tmp http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_x86_64.deb && \
    apt install -y /tmp/Cg-3.1_April2012_x86_64.deb && \
    rm -rf /tmp/Cg-3.1_April2012_x86_64.deb && \
    echo "Adding non-root user..." && \
    useradd -Ums /bin/bash -d /build user && \
    rm -rf /var/lib/apt/lists/*

USER user

VOLUME /build
WORKDIR /build

CMD ["bash"]
