# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake

DESCRIPTION="A port of Glypha (Joust for classic macOS) to modern platforms"
HOMEPAGE="https://github.com/kainjow/glypha"
SRC_URI="https://github.com/kainjow/Glypha/archive/v2.0.1.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Glypha-${PV}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5i
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
		dev-qt/qtmultimedia:5"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=( -DHAVE_QT=true )

	cmake_src_configure
}

