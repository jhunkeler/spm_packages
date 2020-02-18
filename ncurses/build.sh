#!/bin/bash
name=ncurses
version=6.1
revision=0
sources=(
    "http://mirror.rit.edu/gnu/${name}/${name}-${version}.tar.gz"
)
build_depends=(
    "automake"
    "autoconf"
)
depends=()


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
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
      echo "INPUT(-l${lib}w)" > "${_pkgdir}/${_prefix}/lib/lib${lib}.so"
      ln -s ${lib}w.pc "${_pkgdir}/${_prefix}/lib/pkgconfig/${lib}.pc"
    done

    for lib in tic tinfo; do
      echo "INPUT(libncursesw.so.${version:0:1})" > "${_pkgdir}/${_prefix}/lib/lib${lib}.so"
      ln -s libncursesw.so.${version:0:1} "${_pkgdir}/${_prefix}/lib/lib${lib}.so.${version:0:1}"
      ln -s ncursesw.pc "${_pkgdir}${_prefix}/lib/pkgconfig/${lib}.pc"
    done

    # some packages look for -lcurses during build
    echo 'INPUT(-lncursesw)' > "${_pkgdir}${_prefix}/lib/libcursesw.so"
    ln -s libncurses.so "${_pkgdir}/${_prefix}/lib/libcurses.so"

    # some packages include from ncurses/
    ln -s ncursesw "${_pkgdir}/${_prefix}/include/ncurses"

}
