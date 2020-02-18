#!/bin/bash
name=python-pip
version=19.2.3
revision=0
sources=(https://github.com/pypa/${name/python-/}/archive/${version}.tar.gz)
depends=(
    'git'
    'python'
    'python-setuptools'
)

function prepare() {
    tar xf ${version}.tar.gz
    cd ${name/python-/}-${version}
}

function package() {
    python setup.py install --root="${_pkgdir}" --prefix="${_prefix}"
    #find ${_pkgdir} -type f | xargs sed -i -e "s|${build_runtime}|${_prefix}|g"
}
