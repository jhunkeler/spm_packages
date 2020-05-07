#!/bin/bash
name=libXau
version=1.0.9
revision=0
sources=(
    "https://www.x.org/archive/individual/lib/${name}-${version}.tar.gz"
)
build_depends=(
    "pkgconf"
)
depends=(
    "xorg-util-macros"
    "xorg-xproto"
)

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}"
    fi
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
