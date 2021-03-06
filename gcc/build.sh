#!/bin/bash
disable_base=1
name=gcc
version=8.4.0
version_cloog=0.18.4
revision=0
sources=(
    "http://mirrors.concertpass.com/${name}/releases/${name}-${version}/${name}-${version}.tar.gz"
    "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-${version_cloog}.tar.gz"
)
build_depends=(
    "bzip2"
    "zlib"
)
depends=(
    "isl"
    "mpc"
    "mpfr"
    "gmp"
    "zlib"
)
[[ $(uname -s) == Linux ]] && depends+=("binutils")

src=${name}-${version}
blddir=${src}_build

function prepare() {
    tar xf ${name}-${version}.tar.gz
    tar xf cloog-${version_cloog}.tar.gz -C ${src}
    pushd ${src}
        ln -s cloog-${version_cloog} cloog
        cp gcc/Makefile.in gcc/Makefile.in.orig
        sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in
        #sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64
        #./contrib/download_prerequisites
    popd
    mkdir -p ${blddir}
    cd "${blddir}"
}

function build() {
    unset CFLAGS
    unset CXXFLAGS
    unset CPPFLAGS
    unset LDFLAGS

    opts=()
    if [[ $(uname -s) == Darwin ]]; then
        sdk_path=$(xcrun --sdk macosx --show-sdk-path)
        opts+=(--with-native-system-header-dir=/usr/include)
        opts+=(--with-sysroot="${sdk_path}")
    fi

    ../${src}/configure \
            --prefix=${_prefix} \
            --libdir=${_prefix}/lib \
            --libexecdir=${_prefix}/libexec \
            --includedir=${_prefix}/include \
            --enable-bootstrap \
            --disable-multilib \
            --disable-werror \
            --disable-libunwind-exceptions \
            --disable-libstdcxx-pch \
            ${opts[@]} \
            --with-system-zlib \
            --with-tune=generic \
            --with-gmp=${_runtime} \
            --with-mpc=${_runtime} \
            --with-mpfr=${_runtime} \
            --enable-languages=c,c++,fortran,lto \
            --enable-shared \
            --enable-threads=posix \
            --enable-__cxa_atexit \
            --enable-lto \
            --enable-plugin \
            --enable-install-libiberty \
            --enable-cet=auto \
            --enable-checking=release
    make -j${_maxjobs}
}

function package() {
    mkdir -p "${_pkgdir}${_prefix}"/lib

    if [[ $(uname -s) == Linux ]]; then
        pushd "${_pkgdir}${_prefix}"
            ln -sf lib lib64
        popd
    fi

    make install-strip DESTDIR="${_pkgdir}"

    #mv "${_pkgdir}${_prefix}"/lib/gcc/* "${_pkgdir}${_prefix}"
    #rm -rf "${_pkgdir}${_prefix}/lib/gcc"

    pushd "${_pkgdir}${_prefix}"
        pushd bin
            # support generic calls
            ln -sf gcc cc
            ln -sf gcc cc-8
        popd
    popd
}
