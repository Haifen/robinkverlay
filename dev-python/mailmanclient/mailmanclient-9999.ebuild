# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy )

inherit distutils-r1 git-r3

DESCRIPTION="Python bindings for the Mailman 3 REST API."
HOMEPAGE="https://launchpad.net/mailman.client"
EGIT_REPO_URI="https://gitlab.com/mailman/mailmanclient.git"

PATCHES=( "${FILESDIR}/${P}-api31.patch" )

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/httplib2[${PYTHON_USEDEP}]
dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

