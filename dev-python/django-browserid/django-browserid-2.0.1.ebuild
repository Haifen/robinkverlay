# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Django application for adding BrowserID support."
HOMEPAGE="https://github.com/mozilla/django-browserid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
"
RDEPEND="${RDEPEND}"
