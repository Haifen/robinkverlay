# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit autotools git-r3

DESCRIPTION="Samsung's exfat-utils ExFAT utility set to accompany their kernel driver"
HOMEPAGE="https://github.com/exfat-utils/exfat-utils"
EGIT_REPO_URI="https://github.com/exfat-utils/exfat-utils"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

