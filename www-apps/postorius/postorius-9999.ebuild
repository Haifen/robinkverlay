# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
#WEBAPP_NO_AUTO_INSTALL="yes"

inherit distutils-r1 git-r3

DESCRIPTION="A web user interface for GNU Mailman"
HOMEPAGE="https://launchpad.net/postorius"
EGIT_REPO_URI="https://gitlab.com/mailman/postorius.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apache2"

DEPEND="
virtual/httpd-cgi
apache2? ( www-apache/mod_wsgi[${PYTHON_USEDEP}] )
>=dev-python/django-1.6[${PYTHON_USEDEP}]
dev-python/django-browserid[${PYTHON_USEDEP}]
dev-python/mailmanclient[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_fetch "https://gitlab.com/mailman/postorius_standalone.git" "master"
	git-r3_checkout "https://gitlab.com/mailman/postorius_standalone.git" "${WORKDIR}/postorius_standalone"
	git-r3_src_unpack
}

src_install() {
	insinto /usr/share/postorius
	doins "${EGIT_CHECKOUT_DIR}"/{manage,settings,urls,wsgi}.py
	distutils-r1_src_install
}

pkg_postint() {
	elog "Example config files have been installed in /usr/share/postorius"
}
