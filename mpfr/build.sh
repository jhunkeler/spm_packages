#!/bin/bash
name=mpfr
version=3.1.4
revision=0
sources=(
    "https://gcc.gnu.org/pub/gcc/infrastructure/${name}-${version}.tar.bz2"
)
build_depends=(
    "bzip2"
)
depends=(
    "gmp"
)

function prepare() {
    tar xf ${name}-${version}.tar.bz2
    cd ${name}-${version}
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
