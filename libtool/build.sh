#!/bin/bash
name=libtool
version=2.4.6
revision=0
sources=(
    "http://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
    "m4"
)
depends=(
    "tar"
)

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
    if [[ $(uname) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
    fi
}

function build() {
    ./configure --prefix="${_prefix}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
