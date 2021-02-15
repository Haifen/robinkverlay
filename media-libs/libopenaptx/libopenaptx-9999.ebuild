# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit multilib git-r3

DESCRIPTION="Open Source implementation of Audio Processing Technology codec (aptX)"
HOMEPAGE="https://github.com/pali/libopenaptx"
EGIT_REPO_URI="https://github.com/pali/libopenaptx"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
		emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)" install
}

