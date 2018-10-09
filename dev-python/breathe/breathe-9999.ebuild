# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="ReStructuredText and Sphinx bridge to Doxygen"
HOMEPAGE="http://breathe.readthedocs.org/"
EGIT_REPO_URI="git://github.com/michaeljones/breathe"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="${PYTHON_DEPS}
		dev-python/docutils
		dev-python/sphinx
		app-doc/doxygen"
RDEPEND="${DEPEND}"

# Todo: Modify src_compile/src_install to actually generate and install the
# docs.

