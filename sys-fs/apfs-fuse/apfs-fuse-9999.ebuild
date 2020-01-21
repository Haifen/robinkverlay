# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake git-r3

DESCRIPTION="FUSE driver for APFS (Apple File System)"
HOMEPAGE="https://github.com/sgan81/apfs-fuse"
EGIT_REPO_URI="https://github.com/sgan81/apfs-fuse"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="sys-fs/fuse:3
		sys-libs/zlib
		app-arch/bzip2
		sys-apps/attr"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/${P}-Add-library-install-directives.patch"
