#!/bin/bash
name=libuuid
version=2.34
revision=0
sources=(
    "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.34/util-linux-2.34.tar.xz"
    "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${version}/util-linux-${version}.tar.xz"
)
build_depends=(
    "automake"
    "autoconf"
    "xz"
)
depends=()


function prepare() {
    tar xf util-linux-${version}.tar.xz
    cd util-linux-${version}
}

function build() {
    ./configure --prefix=${_prefix} \
        --disable-all-programs \
        --enable-libuuid \
        --without-systemd \
        --without-btrf
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    rm -r "${_pkgdir}/${_prefix}/sbin"
}
