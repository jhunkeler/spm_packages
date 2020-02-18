#!/bin/bash
name=python-setuptools
version=41.2.0
revision=0
sources=(https://github.com/pypa/setuptools/archive/v${version}.tar.gz)
depends=('python')

function prepare() {
    tar xf v${version}.tar.gz
    cd ${name/python-/}-${version}
}

function package() {
    python bootstrap.py
    python setup.py install --root="${_pkgdir}" --prefix="${_prefix}"
    #find ${_pkgdir} -type f | xargs -I'{}' sed -i -e "s|${build_runtime}|${_prefix}|g" '{}'
}
