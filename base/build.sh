#!/bin/bash
name=base
version=1.0.0
revision=0
sources=()
depends=(
    # development tools
    #"autoconf"
    #"automake"
    "binutils"
    "gcc"
    #"m4"
    # file manipulation
    #"diffutils"
    #"findutils"
    #"grep"
    #"sed"
    #"patch"
    "patchelf"
    # archivers
    #"tar"
    # compression
    #"bzip2"
    #"gzip"
    #"xz"
    #"zlib"
    # terminal
    #"ncurses"
    #"readline"
    # web
    #"curl"
)

function prepare() {
    :
}

function build() {
    :
}

function package() {
    dest="${_pkgdir}/${_prefix}"
    schema=(
        bin
        etc
        lib
        libexec
        opt
        sbin
        tmp
        var/cache
        var/db
        var/empty
        var/games
        var/local
        var/log
        var/lock
        var/lib
        var/opt
        var/run
        var/tmp
    )
    mkdir -p "${dest}"
    pushd "${dest}"
        for d in "${schema[@]}"; do
            mkdir -p "${d}"
            chmod 0755 "${d}"
        done
        chmod 1777 tmp
        chmod 1777 var/tmp
        ln -sf lib lib64
    popd

}
