# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PYTHON_COMPAT=( python3_5 python3_6 python3_7 python3_8 )

inherit gnome2 python-r1

DESCRIPTION="Document layout analysis and optical character recognition system"
HOMEPAGE="http://live.gnome.org/OCRFeeder"
SRC_URI="https://gitlab.gnome.org/GNOME/ocrfeeder/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+unpaper tesseract gocr"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# TODO python
DEPEND="
	${PYTHON_DEPS}
	app-text/gtkspell:3
	dev-python/pillow[scanner]
	dev-python/pyenchant
	x11-libs/goocanvas[introspection]
	app-text/gnome-doc-utils
	dev-python/reportlab

	gocr? ( app-text/gocr )
	unpaper? ( app-text/unpaper )
	tesseract? ( app-text/tesseract )
	"
RDEPEND="${DEPEND}"

pkg_setup() {
		python_setup
}

src_prepare() {
		gnome2_src_prepare
		python_copy_sources
}

src_configure() {
		python_foreach_impl run_in_build_dir gnome2_src_configure
}

src_compile() {
		python_foreach_impl run_in_build_dir emake
}

src_test() {
		python_foreach_impl run_in_build_dir emake check
}

src_install() {
		python_foreach_impl run_in_build_dir gnome2_src_install
		python_fix_shebang "${D}/usr/bin"
}

