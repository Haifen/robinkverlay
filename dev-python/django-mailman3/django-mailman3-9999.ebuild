# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1 git-r3

DESCRIPTION="A Django library to help interaction with Mailman"
HOMEPAGE="https://gitlab.com/mailman/django-mailman3"
EGIT_REPO_URI="https://gitlab.com/mailman/django-mailman3.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/django-1.8
		dev-python/mailmanclient
		dev-python/django-allauth
		>=dev-python/django-gravatar2-1.0.6
		dev-python/pytz"
RDEPEND="${DEPEND}"

