# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools git-r3 multilib-minimal

DESCRIPTION="libbitcoin asynchronous C++ library for Bitcoin"
HOMEPAGE="http://libbitcoin.org/"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin.git"
EGIT_BRANCH="version3"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug doc examples icu leveldb png qrencode"

RDEPEND="
	>=dev-libs/boost-1.56.0
	icu? ( >=dev-libs/icu-54.1 )
	png? ( >=media-libs/libpng-1.6.19 )
	qrencode? ( >=media-gfx/qrencode-3.4.4 )
	leveldb? ( dev-libs/leveldb )
	>=dev-libs/openssl-0.9
	dev-libs/libsecp256k1
"

src_prepare() {
		eautoreconf
		eapply_user
}

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.7
"

multilib_src_configure() {
	local myconf=()
	myconf+=( $(use_with examples) $(use_with icu) $(use_with png) $(use_with qrencode) $(use_enable !debug ndebug) $(use_enable leveldb) )
	ECONF_SOURCE="${S}" econf "${myconf[@]}" || die "Configure failed"
}

multilib_src_compile() {
	emake || die "Compile failed"
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

