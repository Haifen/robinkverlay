# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools bash-completion-r1 git-r3

DESCRIPTION="Bitcoin full node based on libbitcoin-blockchain"
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-node"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-node"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="bash-completion console"

DEPEND=">=dev-libs/boost-1.57.0
		>=net-p2p/libbitcoin-blockchain-4.0.0
		>=net-p2p/libbitcoin-network-4.0.0"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
		local myconf=( )
		myconf+=( $(use_with console) )
		use bash-completion && myconf+=( "--with-bash-completiondir=$(get_bashcompdir)" )
		econf "${myconf[@]}" || die "Configure failed."
}

