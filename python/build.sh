#!/bin/bash -x
name=python
version=3.8.2
_basever=${version%.*}
revision=0
sources=(
    "https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz"
)
build_depends=(
    "grep"
    "sed"
    "pkgconf"
    "xz"
    "tk==8.6.9"
)
depends=(
    "bzip2"
    $([[ $(uname) == Linux ]] && echo "e2fsprogs")
    "gdbm"
    "gzip"
    "libexpat"
    "libffi"
    "ncurses"
    "openssl==1.1.1d"
    "tar"
    "tk==8.6.9"
    "readline"
    "sqlite"
    "zlib"
)
lib_type=so


function prepare() {
    tar xf Python-${version}.tar.xz
    cd Python-${version}

    if [[ $(uname -s) == Darwin ]]; then
        lib_type=dylib
    fi
}

function build() {
    #zlib="zlib zlibmodule.c ${CFLAGS} ${LDFLAGS} -lz"
    #echo "${zlib/=/ }" >> Modules/Setup

    export CFLAGS="${CFLAGS} -I${_runtime}/include/ncursesw"
    ./configure \
        --prefix="${_prefix}" \
        --libdir="${_prefix}/lib" \
        --enable-ipv6 \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
        $([[ $bootstrap == 0 ]] && echo --with-tcltk-includes="$(pkg-config --cflags tcl) $(pkg-config --cflags tk)") \
        $([[ $bootstrap == 0 ]] && echo --with-tcltk-libs="$(pkg-config --libs tcl) $(pkg-config --libs tk)") \
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

    if [[ -f "${_pkgdir}/${_prefix}"/lib/libpython${_basever}m.${lib_type} ]]; then
        chmod 755 "${_pkgdir}/${_prefix}"/lib/libpython${_basever}m.${lib_type}
    fi

    if [[ -f "${_pkgdir}/${_prefix}"/lib/libpython${_basever%.*}.${lib_type} ]]; then
        chmod 755 "${_pkgdir}/${_prefix}"/lib/libpython${_basever%.*}.${lib_type}
    fi
}
