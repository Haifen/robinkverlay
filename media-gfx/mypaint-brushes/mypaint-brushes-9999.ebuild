# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="Default MyPaint brushes"
HOMEPAGE="https://github.com/mypaint/mypaint-brushes"
EGIT_REPO_URI="https://github.com/mypaint/mypaint-brushes"

LICENSE="CC0-1.0"
SLOT="2.0"  # due to pkgconfig name "mypaint-brushes-2.0"
KEYWORDS=""
IUSE=""

DOCS=( AUTHORS NEWS README.md )  # to exclude README symlink

src_prepare() {
	eapply_user
	eautoreconf
}
