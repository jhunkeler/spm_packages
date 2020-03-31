#!/bin/bash
name=xcb-util
version=0.4.0
revision=0
sources=(
    "https://www.x.org/archive/individual/xcb/${name}-${version}.tar.gz"
)
build_depends=(
    "pkgconf"
)
depends=(
    "libxcb"
    "libXau"
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
