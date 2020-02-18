#!/bin/bash
name=tar
version=1.32
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
)
depends=(
    "bzip2"
    "gzip"
    "xz"
    "zlib"
)


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    export FORCE_UNSAFE_CONFIGURE=1
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


