# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit distutils

DESCRIPTION="Tools for building Google Compute Engine image bundles"
HOMEPAGE="http://github.com/GoogleCloudPlatform/compute-image-packages"
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/python:2.7"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

