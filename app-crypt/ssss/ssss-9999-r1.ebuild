# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils git-r3

EGIT_REPO_URI="https://github.com/jmesmon/${PN}"
KEYWORDS=""

DESCRIPTION="ssss is an implementation of Shamir's secret sharing scheme for UNIX/linux machines"
HOMEPAGE="http://point-at-infinity.org/ssss/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}
	app-doc/xmltoman"

src_prepare() {
		default
}

src_install() {
	dobin ssss-split ssss-combine
	doman ssss.1
}

