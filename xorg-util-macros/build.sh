#!/bin/bash
name=xorg-util-macros
version=1.19.2
revision=0
sources=(
    "https://www.x.org/archive/individual/util/util-macros-${version}.tar.gz"
)
build_depends=()
depends=()

function prepare() {
    tar xf util-macros-${version}.tar.gz
    cd util-macros-${version}
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
