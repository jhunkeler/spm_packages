#!/bin/bash
name=pkg-config
version=0.29.2
revision=0
sources=(
    "https://pkg-config.freedesktop.org/releases/${name}-${version}.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
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


