# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools bash-completion-r1 git-r3

DESCRIPTION="The Bitcoin command-line tool"
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-explorer"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-explorer"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion +console +icu +qrencode"

DEPEND=">=dev-libs/boost-1.57.0
		media-libs/libpng
		>=net-p2p/libbitcoin-client-4.0.0
		>=net-p2p/libbitcoin-network-4.0.0
		bash-completion? ( app-shells/bash-completion )
		icu? ( dev-libs/icu )
		qrencode? ( media-gfx/qrencode )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=()
	local support_defines=()
	use bash-completion && myconf+=( "--with-bash-completiondir=$(get_bashcompdir)" )
	myconf+=( $(use_with console) )
	use icu && support_defines+=( "-DWITH_ICU" )
	use qrencode && support_defines+=( "-DWITH_QRENCODE" )
	econf "${myconf[@]}" CFLAGS="${support_defines[*]}"  || die "Configure failed."
}

