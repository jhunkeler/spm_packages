#!/bin/bash
name=python
version=3.7.5
_basever=${version%.*}
revision=0
sources=(
    "https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz"
)
build_depends=(
    "sed"
    "grep"
    "automake"
    "autoconf"
    "xz"
)
depends=(
    "bzip2"
    "e2fsprogs"
    "gdbm"
    "gzip"
    "libexpat"
    "libffi"
    "ncurses"
    "openssl==1.1.1d"
    "tar"
    "readline"
    "sqlite"
    "tk"
    "zlib"
)


function prepare() {
    tar xf Python-${version}.tar.xz
    cd Python-${version}
}

function build() {
    #zlib="zlib zlibmodule.c ${CFLAGS} ${LDFLAGS} -lz"
    #echo "${zlib/=/ }" >> Modules/Setup

    export CFLAGS="${CFLAGS} -I${build_runtime}/include/ncursesw"
    ./configure \
        --prefix="${_prefix}" \
        --enable-ipv6 \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
        --with-computed-gotos \
        --with-dbmliborder=gdbm:ndbm \
        --with-pymalloc \
        --with-system-expat \
        --without-ensurepip
    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"
    echo "Removing __pycache__ directories..."
    find "${_pkgdir}" -name "__pycache__" | xargs rm -rf

    ln -s python3             "${_pkgdir}/${_prefix}"/bin/python
    ln -s python3-config      "${_pkgdir}/${_prefix}"/bin/python-config
    ln -s idle3               "${_pkgdir}/${_prefix}"/bin/idle
    ln -s pydoc3              "${_pkgdir}/${_prefix}"/bin/pydoc
    ln -s python${_basever}.1 "${_pkgdir}/${_prefix}"/share/man/man1/python.1
    chmod 755 "${_pkgdir}/${_prefix}"/lib/libpython${_basever}m.so
}


