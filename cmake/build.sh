#!/bin/bash
name=cmake
version=3.15.5
revision=0
sources=(
    "https://github.com/Kitware/CMake/releases/download/v${version}/${name}-${version}.tar.gz"
)
depends=(
    "curl"
)


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./bootstrap --prefix="${_prefix}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


