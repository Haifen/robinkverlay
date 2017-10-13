# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} )
inherit distutils-r1 git-r3

DESCRIPTION="Django applications addressing authentication, registration, account management as well as 3rd party (social) account authentication."
HOMEPAGE="https://github.com/pennersr/django-allauth"
EGIT_REPO_URI="https://github.com/pennersr/django-allauth"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE=""

DEPEND=">=dev-python/django-1.8
		$(python_gen_cond_dep 'dev-python/python-openid' python2_7)
		$(python_gen_cond_dep 'dev-python/python3-openid' python3_{4,5,6})
		>=dev-python/requests-oauthlib-0.3.0
		dev-python/requests"
RDEPEND="${DEPEND}"

