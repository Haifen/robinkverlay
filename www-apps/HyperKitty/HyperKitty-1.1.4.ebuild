# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="A web interface to access GNU Mailman v3 archives"
HOMEPAGE="https://gitlab.com/mailman/hyperkitty"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
EGIT_REPO_URI="https://gitlab.com/mailman/hyperkitty_standalone.git"
EGIT_COMMIT="v1.1.4"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}_standalone"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="apache2"

DEPEND="
virtual/cron
virtual/httpd-cgi
apache2? ( www-apache/mod_wsgi[${PYTHON_USEDEP}] )
|| ( >=dev-python/django-1.7[${PYTHON_USEDEP}] ( >=dev-python/django-1.6[${PYTHON_USEDEP}] >=dev-python/south-1.0[${PYTHON_USEDEP}] ) )
>=dev-python/django-gravatar2-1.0.6[${PYTHON_USEDEP}]
>=dev-python/python-social-auth-0.2.3[${PYTHON_USEDEP}]
>=dev-python/djangorestframework-3.0.0[${PYTHON_USEDEP}]
>=dev-python/django-crispy-forms-1.4.0[${PYTHON_USEDEP}]
>=dev-python/rjsmin-1.0.6[${PYTHON_USEDEP}]
>=dev-python/cssmin-0.2.0[${PYTHON_USEDEP}]
>=dev-python/robot-detection-0.3[${PYTHON_USEDEP}]
>=dev-python/pytz-2012[${PYTHON_USEDEP}]
>=dev-python/django-paintstore-0.1.2[${PYTHON_USEDEP}]
>=dev-python/django-compressor-1.3[${PYTHON_USEDEP}]
>=dev-python/django-browserid-0.11.1[${PYTHON_USEDEP}]
>=dev-python/mailmanclient-1.0.0[${PYTHON_USEDEP}]
dev-python/python-dateutil[${PYTHON_USEDEP}]
>=dev-python/networkx-1.9.1[${PYTHON_USEDEP}]
>=dev-python/enum34-1.0[${PYTHON_USEDEP}]
>=dev-python/django-haystack-2.1.0[${PYTHON_USEDEP}]
>=dev-python/django-extensions-1.3.7[${PYTHON_USEDEP}]
>=dev-python/lockfile-0.9.1[${PYTHON_USEDEP}]
>=dev-python/whoosh-2.5.7[${PYTHON_USEDEP}]
dev-lang/lessjs
"
RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	default_src_unpack
}

src_install() {
	insinto /usr/share/HyperKitty
	doins "${EGIT_CHECKOUT_DIR}"/{manage,settings,urls,wsgi}.py
	doins "${EGIT_CHECKOUT_DIR}"/{crontab,hyperkitty.apache.conf}
	distutils-r1_src_install
}

pkg_postint() {
	elog "Example config files have been installed in /usr/share/HyperKitty"
}

