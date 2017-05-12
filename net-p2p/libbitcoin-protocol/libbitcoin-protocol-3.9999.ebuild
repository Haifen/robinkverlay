# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION="Bitcoin blockchain query protocol library."
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-protocol"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-protocol"
EGIT_BRANCH="version3"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.57.0
		>=net-libs/zeromq-4.2.0
		>=net-p2p/libbitcoin-3.1.0"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf || die "Configure failed."
}

