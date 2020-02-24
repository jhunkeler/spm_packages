#!/bin/bash
name=filesystem
version=1.0.0
revision=0
sources=()
depends=()

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
        chmod 777 tmp
        chmod 777 var/tmp
        ln -srf lib lib64
    popd

}
