# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools git-r3 multilib-minimal

DESCRIPTION="libbitcoin high performance blockchain database"
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-database"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-database"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug tools"

DEPEND=">=net-p2p/libbitcoin-4.0.0
		>=dev-libs/boost-1.57.0"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

multilib_src_configure() {
	local myconf=()
	myconf+=( $(use_with tools) )
	myconf+=( $(use_enable !debug ndebug) )
	ECONF_SOURCE="${S}" econf "${myconf[@]}" || die "Configure failed."
}

