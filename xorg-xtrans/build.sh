#!/bin/bash
name=xorg-xtrans
shortname=xtrans
version=1.4.0
revision=0
sources=(
    "https://www.x.org/archive/individual/lib/${shortname}-${version}.tar.gz"
)
build_depends=(
    "pkgconf"
)
#depends=(
#    "xorg-util-macros"
#    "xorg-xproto"
#)

function prepare() {
    tar xf ${shortname}-${version}.tar.gz
    cd ${shortname}-${version}
}

function build() {
    ./configure --prefix=${_prefix}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
