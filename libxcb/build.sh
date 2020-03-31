#!/bin/bash
name=libxcb
version=1.14
revision=0
sources=(
    "https://www.x.org/archive/individual/xcb/${name}-${version}.tar.gz"
)
build_depends=(
    "pkgconf"
    "python"
)
depends=(
    "libXau"
    "xorg-util-macros"
    "xcb-proto"
)

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
