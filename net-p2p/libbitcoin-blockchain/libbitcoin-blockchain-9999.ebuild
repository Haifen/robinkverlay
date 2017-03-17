# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-blockchain"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-blockchain"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="+consensus tools"

DEPEND=">=dev-libs/boost-1.57.0
		>=net-p2p/libbitcoin-database-4.0.0
		consensus? ( >=net-p2p/libbitcoin-consensus-4.0.0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=()
	myconf+=( $(use_with consensus) $(use_with tools) )
	econf "${myconf[@]}" || die "Configure failed"
}

