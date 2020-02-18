#!/bin/bash
name=tcl
version=8.6.9
revision=0
sources=(
    "https://prdownloads.sourceforge.net/${name}/${name}${version}-src.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
)
depends=(
    "pcre"
)

function prepare() {
    tar xf ${name}${version}-src.tar.gz
    cd ${name}${version}
}

function build() {
    cd unix
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    chmod 755 "${_pkgdir}/${_prefix}"/lib/*.so
}
