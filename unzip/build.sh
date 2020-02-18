#!/bin/bash
name=unzip
version=6.0
revision=0
sources=(
    "https://downloads.sourceforge.net/infozip/${name}${version//./}.tar.gz"
)
build_depends=(
    "bzip2"
)
depends=(
    "bzip2"
)


function prepare() {
    tar xf ${name}${version//./}.tar.gz
    cd ${name}${version//./}
}

function build() {

    # DEFINES, make, and install args from Debian
    DEFINES='-DACORN_FTYPE_NFS -DWILD_STOP_AT_DIR -DLARGE_FILE_SUPPORT \
        -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DNO_LCHMOD \
        -DDATE_FORMAT=DF_YMD -DUSE_BZIP2 -DNOMEMCPY -DNO_WORKING_ISPRINT'

    make -f unix/Makefile prefix="${_pkgdir}${_prefix}" \
        D_USE_BZ2=-DUSE_BZIP2 \
        L_BZ2=-lbz2 \
        LF2="$LDFLAGS" \
        CF="$CFLAGS $CPPFLAGS -I. $DEFINES" \
        unzips
}

function package() {
    make -f unix/Makefile \
        install \
        prefix="${_pkgdir}${_prefix}"
}
