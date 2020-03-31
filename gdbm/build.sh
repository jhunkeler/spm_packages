#!/bin/bash
name=gdbm
version=1.18.1
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
)
depends=(
    "readline"
)


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./configure --prefix=${_prefix} --enable-libgdbm-compat
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
