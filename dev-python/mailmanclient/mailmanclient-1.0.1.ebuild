# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Python bindings for the Mailman 3 REST API."
HOMEPAGE="https://launchpad.net/mailman.client"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/httplib2[${PYTHON_USEDEP}]
dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
