# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin.git"
inherit autotools git-r3 multilib-minimal

DESCRIPTION="libbitcoin asynchronous C++ library for Bitcoin"
HOMEPAGE="http://libbitcoin.org/"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+leveldb testnet debug doc"

RDEPEND="
	>=dev-libs/boost-1.48.0
	>=dev-libs/openssl-0.9
	dev-libs/libsecp256k1
	leveldb? ( dev-libs/leveldb )
"

src_prepare() {
		eautoreconf
		default
}

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.7
"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable leveldb) $(use_enable testnet) $(use_enable debug) || die "Configure failed"
}

multilib_src_compile() {
	emake || die "Compile failed"
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

