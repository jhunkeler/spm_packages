#!/bin/bash
name=pkgconf
version=1.6.3
revision=0
sources=(
    "https://github.com/${name}/${name}/archive/${name}-${version}.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
    "m4"
    "libtool"
)
depends=()

function prepare() {
    tar xf ${name}-${version}.tar.gz
    # an ugly release tag makes for an ugly directory, fyi
    cd ${name}-${name}-${version}
}

function build() {
    ./autogen.sh
    ./configure --prefix="${_prefix}" \
        --sysconfdir="${_prefix}/etc" \
        --with-pkg-config-dir="${_prefix}/lib/pkgconfig:${prefix}/share/pkgconfig:/usr/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig" \
        --with-system-libdir="${_prefix}/lib" \
        --with-system-includedir="${_prefix}/include"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    ln -s pkgconf "${_pkgdir}${_prefix}/bin/pkg-config"
    ln -s pkgconf "${_pkgdir}${_prefix}/bin/x86_64-pc-linux-gnu-pkg-config"
    ln -s pkgconf.1 "${_pkgdir}${_prefix}/share/man/man1/pkg-config.1"
}


