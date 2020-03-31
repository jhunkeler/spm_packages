#!/bin/bash
name=help2man
version=1.47.12
revision=0
sources=(
    "https://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.xz"
)
build_depends=(
    "perl"
    "xz"
)
depends=()

function prepare() {
    tar xf ${name}-${version}.tar.xz
    cd ${name}-${version}
}

function build() {
    ./configure --prefix="${_prefix}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
