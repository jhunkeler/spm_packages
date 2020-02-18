#!/bin/bash
disable_base=1
name=gcc
version=8.2.0
version_cloog=0.18.4
revision=0
sources=(
    "http://mirrors.concertpass.com/${name}/releases/${name}-${version}/${name}-${version}.tar.gz"
    "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-${version_cloog}.tar.gz"
)
depends=()

src=${name}-${version}
blddir=${src}_build


function prepare() {
    tar xf ${name}-${version}.tar.gz
    tar xf cloog-${version_cloog}.tar.gz -C ${src}
    pushd ${src}
        ln -s cloog-${version_cloog} cloog
        sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in
        ./contrib/download_prerequisites
    popd
    mkdir -p ${blddir}
    cd "${blddir}"
}

function build() {
    ../${src}/configure \
            --prefix=${_prefix} \
            --libdir=${_prefix}/lib \
            --disable-bootstrap \
            --disable-multilib \
            --disable-werror \
            --disable-libunwind-exceptions \
            --disable-libstdcxx-pch \
            --disable-libssp \
            --with-system-zlib \
            --with-isl \
            --with-linker-hash-style=gnu \
            --with-tune=generic \
            --enable-languages=c,c++,fortran,lto,go \
            --enable-shared \
            --enable-threads=posix \
            --enable-libmpx \
            --enable-__cxa_atexit \
            --enable-clocale=gnu \
            --enable-gnu-unique-object \
            --enable-linker-build-id \
            --enable-lto \
            --enable-plugin \
            --enable-install-libiberty \
            --enable-gnu-indirect-function \
            --enable-default-pie \
            --enable-default-ssp \
            --enable-cet=auto \
            --enable-checking=release
    make -j${_maxjobs}
}

function package() {
    mkdir -p ${_pkgdir}${_prefix}/lib
    (cd ${_pkgdir}${_prefix} && ln -s lib lib64)

    make install-strip DESTDIR="${_pkgdir}"

    pushd "${_pkgdir}${_prefix}"/bin
        # support generic calls
        ln -sf gcc cc
    popd

    # Binutils build cannot use this static archive
    rm -f "${_pkgdir}${_prefix}/lib/libiberty.a"
}
