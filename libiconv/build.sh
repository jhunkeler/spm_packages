#!/bin/bash
name=libiconv
version=1.16
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
    "gettext"
    "libtool"
)
depends=()

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}"
    fi
}

function build() {
    ./configure --prefix=${_prefix} \
        --enable-shared
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
