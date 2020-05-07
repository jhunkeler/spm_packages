#!/bin/bash
name=perl
version=5.30.1
_baseversion="${version%.*}"
revision=0
sources=(
    "https://www.cpan.org/src/5.0/${name}-${version}.tar.gz"
)
build_depends=(
    "bzip2"
    "gdbm"
    "zlib"
)
depends=(
    "bzip2"
    "readline"
    "zlib"
)
lib_type=so

function prepare() {
    tar xf ${name}-${version}.tar.gz
    cd ${name}-${version}
    if [[ $(uname -s) == Darwin ]]; then
        lib_type=dylib
    fi
}

function build() {
    ./Configure -des \
        -Dusethreads \
        -Duseshrplib \
        -Dusesitecustomize \
        $([[ $(uname -s) == Linux ]] && echo -Ui_ndbm) \
        $([[ $(uname -s) == Linux ]] && echo -Di_gdbm) \
        -Doptimize="${CFLAGS}" \
    	-Dprefix=${_prefix} \
        -Dvendorprefix=${_prefix} \
        -Dlibpth="/usr/local/lib /usr/lib /lib/../lib64 /usr/lib/../lib64 /lib /lib64 /usr/lib64 /usr/local/lib64 ${_prefix}/lib" \
    	-Dprivlib=${_prefix}/share/perl5/core_perl \
    	-Darchlib=${_prefix}/lib/perl5/$_baseversion/core_perl \
    	-Dsitelib=${_prefix}/share/perl5/site_perl \
    	-Dsitearch=${_prefix}/lib/perl5/$_baseversion/site_perl \
    	-Dvendorlib=${_prefix}/share/perl5/vendor_perl \
    	-Dvendorarch=${_prefix}/lib/perl5/$_baseversion/vendor_perl \
    	-Dscriptdir=${_prefix}/bin \
    	-Dsitescript=${_prefix}/bin \
    	-Dvendorscript=${_prefix}/bin \
    	-Dinc_version_list=none \
    	-Dman1ext=1perl \
        -Dman3ext=3perl ${arch_opts} \
        -Dldflags="${LDFLAGS}"

        #-Dccflags="${CFLAGS}" \
    	#-Dlddlflags="-shared ${LDFLAGS}" \

    BUILD_BZIP2=0
    BZIP2_LIB="${_runtime}/lib"
    BZIP2_INCLUDE="${_runtime}/include"
    export BUILD_BZIP2 BZIP2_LIB BZIP2_INCLUDE

    BUILD_ZLIB=0
    ZLIB_LIB="${_runtime}/lib"
    ZLIB_INCLUDE="${_runtime}/include"
    export BUILD_ZLIB ZLIB_LIB ZLIB_INCLUDE

    make -j${_maxjobs}
}

function package() {
    make install DESTDIR="${_pkgdir}"

    # Fix permissions. On Darwin, several files are installed as read-only.
    find "${_pkgdir}" -type f | xargs chmod u+w

    cat << EOF > "${_pkgdir}${_prefix}/share/perl5/site_perl/sitecustomize.pl"
@INC = (
    "${_prefix}/lib/perl5/${_baseversion}/site_perl",
    "${_prefix}/share/perl5/site_perl",
    "${_prefix}/lib/perl5/${_baseversion}/vendor_perl",
    "${_prefix}/share/perl5/vendor_perl",
    "${_prefix}/lib/perl5/${_baseversion}/core_perl",
    "${_prefix}/share/perl5/core_perl",
    ".",
);
EOF
    sed -e '/^man1ext=/ s/1perl/1p/' -e '/^man3ext=/ s/3perl/3pm/' \
    	-i'.orig' "${_pkgdir}${_prefix}/lib/perl5/${_baseversion}/core_perl/Config_heavy.pl"

    sed -e '/(makepl_arg =>/   s/""/"INSTALLDIRS=site"/' \
        -e '/(mbuildpl_arg =>/ s/""/"installdirs=site"/' \
        -i'.orig' "${_pkgdir}${_prefix}/share/perl5/core_perl/CPAN/FirstTime.pm"

    p5lib=$(find ${_pkgdir}${_prefix}/lib -type f -name "libperl.${lib_type}")
    mv "${p5lib}" "${_pkgdir}${_prefix}/lib"
    pushd "$(dirname ${p5lib})"
        ln -s ../../../../libperl.${lib_type}
    popd

    rm -f "${_pkgdir}${_prefix}/bin/perl${version}"

    find "${_pkgdir}" -name perllocal.pod -delete
    find "${_pkgdir}" -name .packlist -delete
}
