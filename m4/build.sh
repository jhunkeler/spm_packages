#!/bin/bash
name=m4
version=1.4.18
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.xz"
)
build_depends=(
    "xz"
    "libsigsegv"
)
depends=(
    "patch"
    "libsigsegv"
)

function prepare() {
    tar xf ${name}-${version}.tar.xz
    cd ${name}-${version}
    patch -p1 -i "../m4-1.4.18-glibc-change-work-around.patch"
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
