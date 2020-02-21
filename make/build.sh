#!/bin/bash
name=make
version=4.3
revision=0
sources=(
    "https://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=()
depends=()

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
