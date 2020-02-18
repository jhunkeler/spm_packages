#!/bin/bash
name=curl
version=7.66.0
revision=0
sources=(
    "https://curl.haxx.se/download/${name}-${version}.tar.xz"
)
build_depends=(
    "tar"
    "xz"
    "autoconf"
    "automake"
)
depends=(
    "libffi>=3.2.1"
    "openssl==1.1.1d"
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
