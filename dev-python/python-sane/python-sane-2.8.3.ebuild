# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Python interface to the SANE scanner and frame grabber"
HOMEPAGE="https://github.com/python-pillow/Sane"
SRC_URI="https://github.com/python-pillow/Sane/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Sane-${PV}"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-gfx/sane-backends"
DEPEND="${RDEPEND}"
