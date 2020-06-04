#!/bin/bash
name=git
version=2.24.0
revision=0
sources=(
    "https://github.com/${name}/${name}/archive/v${version}.tar.gz"
)
build_depends=(
    "autoconf"
    "automake"
    "libtool"
    "pkgconf"
)
depends=(
    "curl"
    "gettext"
    "libiconv"
    "openssl"
    "pcre"
    "perl"
    "python"
    "tk"
    "zlib"
)

function prepare() {
    tar xf v${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
    fi
}

function build() {
    make configure
    ./configure --prefix=${_prefix} \
        --libdir=${_prefix}/lib \
        --with-curl \
        --with-expat \
        --with-tcltk \
        --with-python=${_runtime} \
        --with-perl=${_runtime} \
        --with-zlib=${_runtime}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}


