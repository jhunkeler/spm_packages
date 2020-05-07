#!/bin/bash
name=tk
version=8.6.9
version_full="${version}.1"
revision=0
sources=(
    "https://prdownloads.sourceforge.net/tcl/${name}${version_full}-src.tar.gz"
)
build_depends=(
    "pkgconf"
    "tar"
    "tcl==${version}"
)
depends=(
    $([[ $(uname -s) == Linux ]] && echo "libX11")
    "tcl==${version}"
)
lib_type=so

function prepare() {
    tar xf ${name}${version_full}-src.tar.gz
    cd ${name}${version}

    if [[ $(uname -s) == Darwin ]]; then
        lib_type=dylib
    fi
}

function build() {
    cd unix
    ./configure --prefix=${_prefix} \
        --with-tcl=${_runtime}/lib \
        --with-x
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    pushd "${_pkgdir}/${_prefix}"/bin
        ln -s wish${version%.*} "${_pkgdir}/${_prefix}"/bin/wish
    popd
    chmod 755 "${_pkgdir}/${_prefix}"/lib/*.${lib_type}
}
