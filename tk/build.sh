#!/bin/bash
name=tk
version=8.6.9
version_full="${version}.1"
revision=0
sources=(
    "https://prdownloads.sourceforge.net/tcl/${name}${version_full}-src.tar.gz"
)
build_depends=(
    "tar"
    "automake"
)
depends=(
    "tcl==${version}"
)

function prepare() {
    tar xf ${name}${version_full}-src.tar.gz
    cd ${name}${version}
}

function build() {
    cd unix
    ./configure --prefix=${_prefix} --with-tcl=${build_runtime}/lib
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    chmod 755 "${_pkgdir}/${_prefix}"/lib/*.so
}
