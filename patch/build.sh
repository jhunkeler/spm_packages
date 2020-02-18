#!/bin/bash
name=patch
version=2.7.6
revision=0
sources=(
    "https://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.gz"
)
depends=()

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./configure --prefix="${_prefix}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


