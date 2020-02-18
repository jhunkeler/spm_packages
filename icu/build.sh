#!/bin/bash
name=icu
version=65.1
revision=0
sources=(
    "https://github.com/unicode-org/${name}/releases/download/release-${version//./-}/${name}4c-${version//./_}-src.tgz"
)
build_depends=(
    "automake"
    "autoconf"
    "patch"
    "python"
)
depends=()


function prepare() {
    tar xf ${name}4c-${version//./_}-src.tgz
    cd ${name}/source
    #patch -p0 -i "${build_script_root}/0001-disable-tests.patch"
}

function build() {
    ./runConfigureICU Linux --prefix="${_prefix}"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
}
