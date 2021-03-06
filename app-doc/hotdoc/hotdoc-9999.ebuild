# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1 git-r3

DESCRIPTION="Hotdoc is a documentation micro-framework"
HOMEPAGE="https://hotdoc.github.io"
EGIT_REPO_URI="https://github.com/hotdoc/hotdoc.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}
		dev-util/cmake"
RDEPEND="${DEPEND}"

