#!/bin/bash
name=openssl
version=1.1.1d
revision=0
sources=(
    "https://www.openssl.org/source/${name}-${version}.tar.gz"
)
depends=(
    "zlib"
)


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
    export LDFLAGS="-Wl,-rpath,${_runtime}"
}

function build() {
    export KERNEL_BITS=64
    export TARGET=linux-x86_64

    if [[ $(uname -s) == Darwin ]]; then
        TARGET=darwin64-x86_64-cc
    fi

    ./Configure \
        --prefix="${_prefix}" \
        --openssldir="${_prefix}/etc/ssl" \
        shared \
        threads \
        zlib-dynamic \
        no-ssl3-method \
        ${TARGET}

    #mkdir -p ${_prefix}/{bin,lib,share}
    make -j${_maxjobs}
}

function package() {
    make \
        DESTDIR="${_pkgdir}" \
        MANDIR=${_prefix}/share/man \
        MANSUFFIX=ssl \
        install
}
