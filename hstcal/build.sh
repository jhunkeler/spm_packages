#!/bin/bash
name=hstcal
version=2.3.2
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

_waf_version=2.0.20

function prepare() {
    curl -L https://waf.io/waf-${_waf_version} > waf
    chmod +x waf

    git clone https://github.com/spacetelescope/${name}
    cd ${name}

    if [[ $(uname -s) == Darwin ]]; then
        CC="${_runtime}/bin/gcc"
        LDFLAGS="-L${_runtime}/lib"

        export CC
    fi

    cp wscript ../wscript.orig
    sed -E 's|platform.popen(.*)\.read\(\)|call\1|' ../wscript.orig > wscript
}

function build() {
   ./waf configure --prefix="${_prefix}"
}

function package() {
    ./waf install --destdir="${_pkgdir}"
}


