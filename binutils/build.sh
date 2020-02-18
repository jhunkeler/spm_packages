#!/bin/bash
disable_base=1
name=binutils
version=2.31.1
revision=0
sources=(
    "https://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.gz"
)
depends=("gcc")

src=${name}-${version}
blddir=${src}_build


function prepare() {
    set -x
    tar xf ${name}-${version}.tar.gz
    mkdir -p ${blddir}
    cd "${blddir}"
}

function build() {
    ../${src}/configure \
        --prefix=${_prefix} \
        --libdir=${_prefix}/lib \
        --with-lib-path=${_prefix}/lib:${build_runtime}/lib:/lib64:/usr/lib64:/usr/local/lib64 \
        --target=x86_64-pc-linux-gnu \
        --enable-shared \
        --enable-lto \
        --enable-ld=default \
        --enable-plugins \
        --enable-threads \
        --disable-static \
        --disable-multilib \
        --with-system-zlib \
        --with-sysroot=/ \
        --with-tune=generic
    make -j${_maxjobs}
}

function package() {
    make install-strip DESTDIR="${_pkgdir}"
}
