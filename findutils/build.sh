#!/bin/bash
name=findutils
version=4.7.0
revision=0
sources=(
    "https://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.xz"
)
build_depends=(
    "automake"
    "autoconf"
    "xz"
)
depends=(
)


function prepare() {
    tar xf ${name}-${version}.tar.xz
    cd ${name}-${version}
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


