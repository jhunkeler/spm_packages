#!/bin/bash
name=libffi
version=3.2.1
revision=0
sources=(
    ftp://sourceware.org/pub/libffi/${name}-${version}.tar.gz
)
build_depends=(
    "automake"
    "autoconf"
    "libtool"
)
depends=()


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./configure \
        --prefix=${_prefix} \
        --libdir=${_prefix}/lib \
        --enable-pax_emutramp
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    mv "${_pkgdir}/${_prefix}/lib64"/* "${_pkgdir}/${_prefix}/lib"
    rm -rf "${_pkgdir}/${_prefix}/lib64"
}
