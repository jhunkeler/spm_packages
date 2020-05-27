#!/bin/bash
name=isl
version=0.18
revision=0
sources=(
    "https://gcc.gnu.org/pub/gcc/infrastructure/${name}-${version}.tar.bz2"
)
build_depends=(
    "bzip2"
)
depends=(
    "gmp"
    "mpfr"
)

function prepare() {
    tar xf ${name}-${version}.tar.bz2
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
    fi
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
