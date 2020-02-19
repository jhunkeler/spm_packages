#!/bin/bash
name=libexpat
version=2.2.9
revision=0
sources=(
    "https://github.com/${name}/${name}/archive/R_${version//./_}.tar.gz"
)
build_depends=(
    "autoconf"
    "automake"
    "libtool"
    "m4"
    "gettext"
)
depends=()


function prepare() {
    tar xf R_${version//./_}.tar.gz
    cd ${name}-R_${version//./_}/expat
}

function build() {
    autoreconf -i
    ./configure --prefix="${_prefix}" \
        --libdir="${_prefix}/lib"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


