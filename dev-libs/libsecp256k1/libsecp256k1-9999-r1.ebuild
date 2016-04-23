# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/bitcoin/secp256k1.git"
inherit git-r3 autotools multilib-minimal

MyPN=secp256k1
DESCRIPTION="Optimized C library for EC operations on curve secp256k1"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="asm doc ecdh endomorphism gmp recovery schnorr test"

REQUIRED_USE="
	asm? ( amd64 )
"
RDEPEND="
	gmp? ( dev-libs/gmp:0 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/openssl:0 )
"

src_prepare() {
	eautoreconf
	default
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-benchmark \
		--enable-experimental \
		$(use_enable test tests) \
		$(use_enable endomorphism)  \
		--with-asm=$(usex asm auto no) \
		--with-bignum=$(usex gmp gmp no) \
		--disable-static \
		$(use_enable ecdh module-ecdh) \
		$(use_enable schnorr module-schnorr) \
		$(use_enable recovery module-recovery)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}

multilib_src_install_all() {
	if use doc; then
		dodoc README.md
	fi
}

