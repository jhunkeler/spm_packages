#!/bin/bash
name=hstcal
version=2.3.1
revision=0
sources=()
build_depends=(
    "git"
    "python"
    "gcc==8.4.0"
)
depends=(
    "cfitsio"
)

_waf_version=2.0.18

function prepare() {
    curl -L https://waf.io/waf-${_waf_version} > waf
    chmod +x waf

    git clone https://github.com/spacetelescope/${name}
    cd ${name}
    git checkout ${version}
}

function build() {
    ../waf configure --prefix=${_prefix}
echo debug
bash
}

function package() {
    ../waf install --destdir="${_pkgdir}"
}


