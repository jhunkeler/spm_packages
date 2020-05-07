#!/bin/bash
name=xz
version=5.2.5
revision=0
sources=(
    "https://tukaani.org/xz/${name}-${version}.tar.gz"
)
depends=()


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        # redundant rpath kills the build
        LDFLAGS="-L${_runtime}/lib"
    fi
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


