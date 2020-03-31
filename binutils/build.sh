#!/bin/bash
disable_base=1
name=binutils
version=2.34
revision=0
sources=(
    "https://ftp.gnu.org/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
    "bison"
    "texinfo"
    "m4"
    "zlib"
)
depends=(
    "zlib"
)

src=${name}-${version}
blddir=${src}_build


function prepare() {
    set -x
    tar xf ${name}-${version}.tar.gz
    mkdir -p ${blddir}
    cd "${blddir}"
}

function build() {
    export LD_LIBRARY_PATH="${_runtime}/lib:${_prefix}/lib64"
    export LDFLAGS="$LDFLAGS -L${_runtime}/lib64"
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${_runtime}/lib64/pkgconfig"
    ../${src}/configure \
        --prefix=${_prefix} \
        --libdir=${_prefix}/lib \
        --with-lib-path=${_prefix}/lib:${_runtime}/lib:${_prefix}/lib64:${_runtime}/lib64:/lib64:/usr/lib64:/usr/local/lib:/usr/local/lib64 \
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
