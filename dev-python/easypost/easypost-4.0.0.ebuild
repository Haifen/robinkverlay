# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python2_7 python3_5 python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="Python module for the EasyPost API"
HOMEPAGE="https://github.com/EasyPost/eastypost-python"
SRC_URI="https://files.pythonhosted.org/packages/2d/60/02f50e068035a78b4ec41578e1c46e925a7aa99826fdcfdfde1fcee50be3/easypost-4.0.0.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
