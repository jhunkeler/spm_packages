#!/bin/bash
name=xorg-xproto
shortname=xorgproto
version=2018.2
revision=0
sources=(
    "https://www.x.org/archive/individual/proto/${shortname}-${version}.tar.gz"
)
build_depends=(
)
depends=(
)

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
