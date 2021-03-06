# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="A multiprocessing distributed task queue for Django"
HOMEPAGE="https://django-q.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/django-1.8
		dev-python/django-picklefield
		dev-python/blessed
		dev-python/arrow"
RDEPEND="${DEPEND}"
