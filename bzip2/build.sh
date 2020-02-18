#!/bin/bash
name=bzip2
version=1.0.8
revision=0
sources=(
    https://sourceware.org/pub/bzip2/${name}-${version}.tar.gz
)
depends=()


function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
}

function build() {
    make -f Makefile-libbz2_so CC="gcc $CFLAGS $LDFLAGS"
    make bzip2 bzip2recover CC="gcc $CFLAGS $LDFLAGS"
}

function package() {
    install -dm755 "${_pkgdir}/${_prefix}"/{bin,lib,include,share/man/man1}
    install -m755 bzip2-shared "${_pkgdir}/${_prefix}"/bin/bzip2
    install -m755 bzip2recover bzdiff bzgrep bzmore "${_pkgdir}/${_prefix}"/bin
    ln -sf bzip2 "${_pkgdir}/${_prefix}"/bin/bunzip2
    ln -sf bzip2 "${_pkgdir}/${_prefix}"/bin/bzcat
    cp -a libbz2.so* "${_pkgdir}/${_prefix}"/lib
    ln -s libbz2.so.${version} "${_pkgdir}/${_prefix}"/lib/libbz2.so
    ln -s libbz2.so.${version} "${_pkgdir}/${_prefix}"/lib/libbz2.so.1
    install -m644 bzlib.h "${_pkgdir}/${_prefix}"/include
    install -m644 bzip2.1 "${_pkgdir}/${_prefix}"/share/man/man1
    ln -sf bzip2.1 "${_pkgdir}/${_prefix}"/share/man/man1/bunzip2.1
    ln -sf bzip2.1 "${_pkgdir}/${_prefix}"/share/man/man1/bzcat.1
    ln -sf bzip2.1 "${_pkgdir}/${_prefix}"/share/man/man1/bzip2recover.1
}


