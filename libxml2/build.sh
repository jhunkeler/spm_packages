#!/bin/bash
name=libxml2
version=2.9.9
revision=0
sources=(
    "https://github.com/GNOME/${name}/archive/v${version}.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
    "libtool"
    "pkgconf"
)
depends=(
    "icu"
    "libiconv"
    "xz"
    "zlib"
)

lib_type=so

function prepare() {
    tar xf v${version}.tar.gz
    cd ${name}-${version}
    if [[ $(uname -s) == Darwin ]]; then
        lib_type=dylib
        LDFLAGS="-L${_runtime}"
    fi
}

function build() {
    sh autogen.sh
    ./configure --prefix="${_prefix}" \
        --with-icu \
        --with-iconv="${_runtime}" \
        --with-libz="${_runtime}" \
        --with-lzma="${_runtime}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    if [[ $(uname -s) == Darwin ]]; then
        pushd "${_pkgdir}${_prefix}"
            for prog in bin/xmlcatalog bin/xmllint; do
                install_name_tool -add_rpath "${_runtime}"/lib "$prog"
            done
        popd
    fi
}
