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
    "tcl==${version}"
)
[[ $(uname -s) == Linux ]] && depends+=("libX11")

lib_type=so

function prepare() {
    tar xf ${name}${version_full}-src.tar.gz
    cd ${name}${version}

    if [[ $(uname -s) == Darwin ]]; then
        LDFLAGS="-L${_runtime}/lib"
        lib_type=dylib
    fi
}

function build() {
    cd unix

    # Patch bad library path (originally was, "path1:path2:path3:...")
    cp -a Makefile.in Makefile.in.old
    sed -e "s|^LIB_RUNTIME_DIR.*$|LIB_RUNTIME_DIR=${_runtime}/lib|" Makefile.in.old > Makefile.in

    if [[ $(uname -s) == Darwin ]]; then
        opts="--disable-framework"
    fi

    ./configure --prefix=${_prefix} \
        ${opts} \
        --with-tcl=${_runtime}/lib \
        --with-x
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    pushd "${_pkgdir}${_prefix}"/bin
        ln -s wish${version%.*} "${_pkgdir}${_prefix}"/bin/wish
    popd
    chmod 755 "${_pkgdir}${_prefix}"/lib/*.${lib_type}
}
