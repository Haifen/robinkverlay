# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit git-r3

DESCRIPTION="Wayland event viewer"
HOMEPAGE="https://git.sr.ht/~sircmpwn/wev"
EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/wev/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/wayland"
RDEPEND="${DEPEND}"

src_install() {
	emake PREFIX=${ED}/usr install
}

