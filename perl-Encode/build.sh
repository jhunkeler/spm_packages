cpan_name=Encode
name=perl-${cpan_name}
version=3.03
revision=0

sources=(
    "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/${cpan_name}-${version}.tar.gz"
)

build_depends=(
    "perl"
)
depends=(
    "perl"
)

prepare() {
    tar xf "${cpan_name}-${version}.tar.gz"
    cd "${cpan_name}-${version}"
}

build() {
    perl Makefile.PL
    make
}

package() {
    bash
    make install INSTALLDIRS=vendor DESTDIR="${_pkgdir}"
}
