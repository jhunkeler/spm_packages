#!/bin/bash
name=mpc
version=1.0.3
revision=0
sources=(
    "https://gcc.gnu.org/pub/gcc/infrastructure/${name}-${version}.tar.gz"
)
build_depends=()
depends=(
    "gmp"
    "mpfr"
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
