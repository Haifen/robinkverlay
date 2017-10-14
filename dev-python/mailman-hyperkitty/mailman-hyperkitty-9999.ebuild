# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit distutils-r1 git-r3

DESCRIPTION="Mailman archiver plugin for HyperKitty"
HOMEPAGE="https://fedorahosted.org/hyperkitty/"
EGIT_REPO_URI="https://gitlab.com/mailman/mailman-hyperkitty.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
dev-python/setuptools[${PYTHON_USEDEP}]
dev-python/zope-interface[${PYTHON_USEDEP}]
dev-python/requests[${PYTHON_USEDEP}]
net-mail/mailman-core[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/mailman-hyperkitty
	doins mailman-hyperkitty.cfg
	distutils-r1_src_install
}

