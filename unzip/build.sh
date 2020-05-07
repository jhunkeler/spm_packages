#!/bin/bash
name=unzip
version=6.0
revision=0
sources=(
    "https://downloads.sourceforge.net/infozip/${name}${version//./}.tar.gz"
)
build_depends=(
    "bzip2"
    "tar"
)
depends=(
    "bzip2"
)
debian_patchset=25


function prepare() {
    tar xf ${name}${version//./}.tar.gz
    cd ${name}${version//./}

    curl -LO http://ftp.debian.org/debian/pool/main/u/${name}/${name}_${version}-${debian_patchset}.debian.tar.xz
    tar xf ${name}_${version}-${debian_patchset}.debian.tar.xz

    msg "Apply debian patchset: ${debian_patchset}"
    for p in $(find debian/patches -type f -name "*.patch" | sort); do
        msg2 "$p"
        patch -p1 < "$p"
    done

}

function build() {
    DEFINES=
    if [[ $(uname -s) == Linux ]]; then
        DEFINES='-DACORN_FTYPE_NFS -DWILD_STOP_AT_DIR -DLARGE_FILE_SUPPORT \
            -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DNO_LCHMOD \
            -DDATE_FORMAT=DF_YMD -DUSE_BZIP2 -DNOMEMCPY -DNO_WORKING_ISPRINT'
        LF2="$LDFLAGS"
    elif [[ $(uname -s) == Darwin ]]; then
        DEFINES="-DUNIX -DBSD -DUSE_BZIP2"
        LF2=""
    fi


    echo make -f unix/Makefile \
        D_USE_BZ2=-DUSE_BZIP2 \
        L_BZ2=-lbz2 \
        CF=\"$CFLAGS $CPPFLAGS -I. $DEFINES\" \
        prefix=\"${_pkgdir}${_prefix}\" \
        unzips > run.sh

    chmod +x run.sh
    bash run.sh
}

function package() {
    make -f unix/Makefile \
        install \
        prefix="${_pkgdir}${_prefix}"
}
