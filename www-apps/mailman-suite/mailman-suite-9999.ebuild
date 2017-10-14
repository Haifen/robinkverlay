# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Mailman Suite single-Django-instance setup"
HOMEPAGE="https://gitlab.com/mailman/mailman-suite"
EGIT_REPO_URI="https://gitlab.com/mailman/mailman-suite.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~sparc"
IUSE=""

DEPEND="dev-python/django
		www-apps/HyperKitty
		www-apps/postorius
		dev-python/django-mailman3
		dev-python/mailmanclient"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/share/mailman-suite
	doins "${S}/mailman-suite_project/"{manage,settings,urls,wsgi}.py
}

