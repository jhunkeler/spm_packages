#!/bin/bash
name=gmp
version=6.1.0
revision=0
sources=(
    "https://gcc.gnu.org/pub/gcc/infrastructure/${name}-${version}.tar.bz2"
)
build_depends=(
    "bzip2"
    "m4"
)
depends=()

function prepare() {
    tar xf ${name}-${version}.tar.bz2
    cd ${name}-${version}
}

function build() {
    opts=()

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
        opts+=(--disable-assembly)
    fi

    ./configure --prefix=${_prefix} \
        ${opts[@]}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
