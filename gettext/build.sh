#!/bin/bash
name=gettext
version=0.20.1
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=()
depends=()

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}"
    fi
}

function build() {
    conf=()
    if [[ $(uname -s) == Darwin ]]; then
        conf+=(--with-included-gettext)
        conf+=(--with-included-glib)
        conf+=(--with-included-libcroco)
        conf+=(--with-included-libunistring)
        conf+=(--disable-java)
        conf+=(--disable-csharp)
        conf+=(--without-git)
        conf+=(--without-cvs)
        conf+=(--without-xz)
    fi

    ./configure --prefix=${_prefix} \
        ${conf[@]}
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
