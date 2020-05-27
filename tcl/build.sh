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
lib_type=so

function prepare() {
    tar xf ${name}${version}-src.tar.gz
    cd ${name}${version}

    if [[ $(uname -s) == Darwin ]]; then
        lib_type=dylib
    fi
}

function build() {
    cd unix
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    chmod 755 "${_pkgdir}${_prefix}"/lib/*.${lib_type}
    ln -s tclsh${version%.*} "${_pkgdir}${_prefix}"/bin/tclsh
}
