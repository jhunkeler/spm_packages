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

function use_git_version() {
    version=$( set -o pipefail
        git describe --long 2>/dev/null \
            | sed 's/^[v|V]-//;s/\([^-]*-g\)/r\1/;s/-/\+/g' \
            || printf "r%s+%s" \
            "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
    )
    spm_build_update_metadata
}

function prepare() {
    curl -L https://waf.io/waf-${_waf_version} > waf
    chmod +x waf

    git clone https://github.com/spacetelescope/${name}
    cd ${name}
    use_git_version

    if [[ $(uname -s) == Darwin ]]; then
        CC="${_runtime}/bin/gcc"
        LDFLAGS="-L${_runtime}/lib"

        export CC
    fi
}

function build() {
   ./waf configure --prefix="${_prefix}"
}

function package() {
    ./waf install --destdir="${_pkgdir}"
}


