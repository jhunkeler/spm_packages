#!/bin/bash
name=xcb-proto
version=1.14
revision=0
sources=(
    "https://www.x.org/archive/individual/proto/${name}-${version}.tar.gz"
)
build_depends=(
)
depends=(
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
