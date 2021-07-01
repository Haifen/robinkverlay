# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_8 python3_9 )
inherit distutils-r1

DESCRIPTION="Python module for the EasyPost API"
HOMEPAGE="https://github.com/EasyPost/easypost-python"
SRC_URI="https://files.pythonhosted.org/packages/46/de/a85791657c9de07d94592ac35f951ee28177c3e7ddb68a09773869021080/easypost-5.1.2.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/requests[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
