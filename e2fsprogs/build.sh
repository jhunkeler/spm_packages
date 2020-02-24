#!/bin/bash
name=e2fsprogs
version=1.45.4
revision=0
sources=(
    "https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/${name}/v${version}/${name}-${version}.tar.gz"
)
build_depends=(
    "autoconf"
    "automake"
    "libtool"
    )
depends=()


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    ./configure \
        --prefix=${_prefix} \
        --enable-relative-symlinks \
        --enable-elf-shlibs \
        --enable-libuuid \
        --enable-libblkid
    make -j${_maxjobs}
}

function package() {
    pushd lib/uuid &>/dev/null
        make install DESTDIR="${_pkgdir}"
    popd
    pushd lib/blkid &>/dev/null
        make install DESTDIR="${_pkgdir}"
    popd
}


