#!/bin/bash
name=glib
version=2.63.1
revision=0
sources=(
    "https://download.gnome.org/sources/${name}/2.63/${name}-${version}.tar.xz"
)
build_depends=(
    "automake"
    "autoconf"
    "gettext"
    "xz"
)
depends=(
    "cmake"
    "gettext"
    "python-pip"
)

function prepare() {
    tar xf ${name}-${version}.tar.xz
    cd ${name}-${version}
}

function build() {
    pip install meson
    meson --prefix="${_prefix}" _build
    ninja -C _build
    make -j${_maxjobs}
}

function package() {
    DESTDIR="${destroot}" ninja -C _build install
}
