# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"

inherit cmake-utils multilib wxwidgets

DESCRIPTION="Driver and GUI for LMS7002M-based SDR platforms"
HOMEPAGE="https://github.com/myriadrf/LimeSuite"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/myriadrf/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/myriadrf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="wxwidgets novena +soapysdr examples "

DEPEND="

	virtual/libusb:1
	dev-db/sqlite:3
	wxwidgets? (
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
		>=media-libs/freeglut-3.0.0
	)
	soapysdr? ( net-wireless/soapysdr )"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_configure() {
	setup-wxwidgets

	mycmakeargs=(
		-DENABLE_EXAMPLES=$(usex examples)
		-DENABLE_GUI=$(usex wxwidgets)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}
