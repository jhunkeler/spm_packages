#!/bin/bash
name=pcre
version=8.43
revision=0
sources=(
    "https://ftp.pcre.org/pub/${name}/${name}-${version}.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
    "readline"
    "zlib"
)
depends=(
    "bzip2"
    "readline"
    "zlib"
)

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
    fi
}

function build() {
    ./configure \
        --prefix=${_prefix} \
        --enable-unicode-properties \
        --enable-pcre16 \
        --enable-pcre32 \
        --enable-jit \
        --enable-pcregrep-libz \
        --enable-pcregrep-libbz2 \
        --enable-pcretest-libreadline
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
