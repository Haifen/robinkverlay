# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6} )

MY_PN=mailman
MY_P=${MY_PN}-${PV}

inherit distutils-r1

DESCRIPTION="Mailman -- the GNU mailing list manager"
HOMEPAGE="http://www.list.org"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="postgres"

DEPEND="
virtual/mta
postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
dev-python/alembic[${PYTHON_USEDEP}]
>=dev-python/falcon-0.3.0[${PYTHON_USEDEP}]
dev-python/flufl-bounce[${PYTHON_USEDEP}]
dev-python/flufl-i18n[${PYTHON_USEDEP}]
dev-python/flufl-lock[${PYTHON_USEDEP}]
dev-python/httplib2[${PYTHON_USEDEP}]
dev-python/lazr-config[${PYTHON_USEDEP}]
dev-python/lazr-smtptest[${PYTHON_USEDEP}]
dev-python/mock[${PYTHON_USEDEP}]
dev-python/nose2[${PYTHON_USEDEP}]
dev-python/passlib[${PYTHON_USEDEP}]
dev-python/sqlalchemy[${PYTHON_USEDEP}]
dev-python/zope-component[${PYTHON_USEDEP}]
dev-python/zope-configuration[${PYTHON_USEDEP}]
dev-python/zope-event[${PYTHON_USEDEP}]
dev-python/zope-interface[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}

src_install() {
	newinitd "${FILESDIR}"/mailman-initd mailman
	distutils-r1_src_install
}

pkg_postint() {
	elog "The 3.0 mailman-core package no longer contains an archiver or web ui, you may want to install the new net-mail/mailman meta package"
}

