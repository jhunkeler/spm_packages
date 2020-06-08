#!/bin/bash
name=libffi
version=3.2.1
revision=1
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
    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
    fi
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

    if [[ -d "${_pkgdir}${_prefix}/lib64" ]]; then
        mv "${_pkgdir}${_prefix}/lib64"/* "${_pkgdir}${_prefix}/lib"
        rm -rf "${_pkgdir}${_prefix}/lib64"
    fi
    mv "${_pkgdir}${_prefix}/lib"/${name}-${version}/include "${_pkgdir}${_prefix}"
    rm -rf "${_pkgdir}${_prefix}/lib"/${name}-${version}
}
