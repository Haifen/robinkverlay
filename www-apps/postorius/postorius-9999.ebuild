# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
#WEBAPP_NO_AUTO_INSTALL="yes"

inherit distutils-r1 git-r3

DESCRIPTION="A web user interface for GNU Mailman"
HOMEPAGE="https://launchpad.net/postorius"
EGIT_REPO_URI="https://gitlab.com/mailman/postorius.git"

#PATCHES=( "${FILESDIR}/${P}-List-Index-filter.patch" )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apache2"

DEPEND="
virtual/httpd-cgi
apache2? ( www-apache/mod_wsgi[${PYTHON_USEDEP}] )
>=dev-python/django-1.8[${PYTHON_USEDEP}]
dev-python/mailmanclient[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_unpack() {
#	git-r3_fetch "https://gitlab.com/mailman/postorius_standalone.git" "refs/heads/master" "${CATEGORY}/${PN}/live"
#	git-r3_checkout "https://gitlab.com/mailman/postorius_standalone.git" "${WORKDIR}/postorius_standalone" "${CATEGORY}/${PN}/live"
	git-r3_src_unpack
}

src_install() {
	insinto /usr/share/postorius
	doins "${S}/example_project/"{manage,settings,urls,wsgi}".py"
	distutils-r1_src_install
}

pkg_postint() {
	elog "Example config files have been installed in /usr/share/postorius"
}

