#!/bin/bash
name=bzip2
version=1.0.8
revision=0
sources=(
    https://sourceware.org/pub/${name}/${name}-${version}.tar.gz
)
depends=()

lib_type=so

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}

    if [[ $(uname -s) == Darwin ]]; then
        # Rotate the elder signs 14.8 degrees counter-clockwise
        lib_type=dylib
        cp Makefile Makefile.orig
        cp Makefile-libbz2_so Makefile-libbz2_so.orig
        sed -e 's|$(PREFIX)|$(DESTDIR)$(PREFIX)|g' -e 's|2\.so|2.dylib|g' < Makefile.orig > Makefile
        sed -e 's|-soname|-install_name|g' -e 's|2\.so|2.dylib|g' < Makefile-libbz2_so.orig > Makefile-libbz2_so
    fi
}

function build() {
    make bzip2 bzip2recover CC="gcc $CFLAGS $LDFLAGS"
    make -f Makefile-libbz2_so CC="gcc $CFLAGS $LDFLAGS"
}

function package() {
    # Wow, this makefile is horrible. Fix shared library names.
    lib_format=${lib_type}.${version}
    lib_format_short=${lib_type}.${version%.*}
    if [[ $(uname -s) == Darwin ]]; then
        lib_format_darwin=${version}.${lib_type}
        lib_format_darwin_short=${version%.*}.${lib_type}

        mv libbz2.${lib_format} libbz2.${lib_format_darwin}
        # Remove remaining Linux-style shared libraries
        rm -f libbz2.${lib_type}*

        # Reconstruct symlinks
        ln -s libbz2.${lib_format_darwin} libbz2.${lib_format_darwin_short}
        ln -s libbz2.${lib_format_darwin} libbz2.${lib_type}

        # Reset LC_ID_DYLIB to use expected naming conventions
        install_name_tool -id libbz2.${lib_format_darwin_short} \
            libbz2.${lib_format_darwin}

        lib_format=${lib_format_darwin}
        lib_format_short=${lib_format_darwin_short}
    fi

    # Install bzip2, for what its worth
    make install PREFIX=${_prefix} DESTDIR=${_pkgdir}

    # Install binaries
    cp -a bzip2-shared "${_pkgdir}${_prefix}"/bin/bzip2
    cp -a libbz2.${lib_format} "${_pkgdir}${_prefix}"/lib
    cp -a libbz2.${lib_format_short} "${_pkgdir}${_prefix}"/lib
    cp -a libbz2.${lib_type} "${_pkgdir}${_prefix}"/lib

    # Wow, this makefile is horrible. Destroy symlinks it created.
    for f in "${_pkgdir}${_prefix}"/bin/*; do
        if [[ -L "$f" ]]; then
            rm -f "${f}"
        fi
    done

    # Fix botched copy operation in makefile
    cp -a bzdiff "${_pkgdir}${_prefix}"/bin
    cp -a bzgrep "${_pkgdir}${_prefix}"/bin
    chmod +x bzmore
    cp -a bzmore "${_pkgdir}${_prefix}"/bin

    # Recreate symlinks with relative paths
    ln -sf bzip2 "${_pkgdir}${_prefix}"/bin/bunzip2
    ln -sf bzip2 "${_pkgdir}${_prefix}"/bin/bzcat
    ln -sf bzgrep "${_pkgdir}${_prefix}"/bin/bzfgrep
    ln -sf bzgrep "${_pkgdir}${_prefix}"/bin/bzegrep
    ln -sf bzdiff "${_pkgdir}${_prefix}"/bin/bzcmp
    ln -sf bzmore "${_pkgdir}${_prefix}"/bin/bzless

    # Fix man directory location
    mkdir -p "${_pkgdir}${_prefix}"/share
    mv "${_pkgdir}${_prefix}"/man "${_pkgdir}${_prefix}"/share

    ln -sf bzip2.1 "${_pkgdir}${_prefix}"/share/man/man1/bunzip2.1
    ln -sf bzip2.1 "${_pkgdir}${_prefix}"/share/man/man1/bzcat.1
    ln -sf bzip2.1 "${_pkgdir}${_prefix}"/share/man/man1/bzip2recover.1
}


