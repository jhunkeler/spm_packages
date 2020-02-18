#!/bin/bash
disable_base=1
name=patchelf
version=0.10
revision=0
sources=("https://github.com/NixOS/${name}/archive/${version}.tar.gz")
build_depends=(
    "autoconf"
    "automake"
    "gcc"
    "binutils"
)
depends=()

function prepare() {
    tar xf ${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./bootstrap.sh
    ./configure --prefix="${_prefix}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


