# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-multilib

DESCRIPTION="Intel's fast AV1 encoder suite"
HOMEPAGE="https://github.com/OpenVisualCloud/SVT-AV1"
EGIT_REPO_URI="https://github.com/OpenVisualCloud/SVT-AV1.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/yasm"
RDEPEND="${DEPEND}"
