# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools bash-completion-r1 git-r3

DESCRIPTION="Bitcoin full node and query server"
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-server"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-server"
EGIT_BRANCH="version3"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="bash-completion console debug"

DEPEND=">=dev-libs/boost-1.57.0
		>=net-p2p/libbitcoin-node-3.2.0
		>=net-p2p/libbitcoin-protocol-3.2.0
		bash-completion? ( >=app-shells/bash-completion-2.0 )"
RDEPEND="${DEPEND}"

src_prepare() {
		eapply_user
		eautoreconf
}

src_configure() {
	local myconf=()
	myconf+=( "$(use_with console)" "$(use_with debug ndebug)" )
	use bash-completion && myconf+=( "$(use_with bash-completion bash-completiondir $(get_bashcompdir))" )
	econf "${myconf[@]}" || die "Configure failed."
}

