#!/bin/bash
name=libX11
version=1.6.9
revision=0
sources=(
    "https://www.x.org/archive/individual/lib/${name}-${version}.tar.gz"
)
build_depends=(
    "libtool"
    "pkgconf"
)
depends=(
    "xorg-util-macros"
    "xorg-xproto"
    "xorg-xtrans"
    "xcb-proto"
    "xcb-util"
    "libXau"
    "libxcb"
)

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./configure --prefix=${_prefix} \
        --enable-xthreads \
        --disable-xf86bigfont
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
