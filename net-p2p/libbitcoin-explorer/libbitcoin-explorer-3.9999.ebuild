# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools bash-completion-r1 flag-o-matic git-r3

DESCRIPTION="The Bitcoin command-line tool"
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-explorer"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-explorer"
EGIT_BRANCH="version3"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion +console +icu +qrencode"

DEPEND=">=dev-libs/boost-1.57.0
		media-libs/libpng
		>=net-p2p/libbitcoin-client-3.1.0
		>=net-p2p/libbitcoin-network-3.2.0
		bash-completion? ( >=app-shells/bash-completion-2.0 )
		icu? ( dev-libs/icu )
		qrencode? ( media-gfx/qrencode )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=()
	use bash-completion && myconf+=( "--with-bash-completiondir=$(get_bashcompdir)" )
	myconf+=( $(use_with console) )
	use icu && append-flags "-DWITH_ICU"
	use qrencode && append-flags "-DWITH_QRENCODE"
	econf "${myconf[@]}" || die "Configure failed."
}

