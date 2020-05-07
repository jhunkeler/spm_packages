#!/bin/bash
name=ncurses
version=6.1
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
)
depends=()

lib_type=so

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
    if [[ $(uname -s) == Darwin ]]; then
        lib_type=dylib
    fi
}

function build() {
    ./configure --prefix=${_prefix} \
        --without-static \
        --with-shared \
        --with-normal \
        --without-debug \
        --without-ada \
        --enable-widec \
        --enable-pc-files \
        --with-cxx-bindings \
        --with-cxx-shared \
        --with-manpage-format=normal \
        --with-pkg-config-libdir="${_prefix}/lib/pkgconfig"
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"

    # Arch linux maintainers have the right idea here...

    # fool packages looking to link to non-wide-character ncurses libraries
    for lib in ncurses ncurses++ form panel menu; do
      ln -s lib${lib}w.${lib_type} "${_pkgdir}${_prefix}/lib/lib${lib}.${lib_type}"
      ln -s lib${lib}w.a "${_pkgdir}${_prefix}/lib/lib${lib}.a"
      ln -s ${lib}w.pc "${_pkgdir}${_prefix}/lib/pkgconfig/${lib}.pc"
    done

    # some packages look for -lcurses during build
    #echo 'INPUT(-lncursesw)' > "${_pkgdir}${_prefix}/lib/libcursesw.so"
    ln -s libncurses.${lib_type} "${_pkgdir}${_prefix}/lib/libcurses.${lib_type}"

    # some packages include from ncurses/
    ln -s ncursesw "${_pkgdir}${_prefix}/include/ncurses"

}
