# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base flag-o-matic

DESCRIPTION="Powerful, industrial-strength vector-based 2D animation software package"
HOMEPAGE="http://www.synfig.org/"
SRC_URI="mirror://sourceforge/synfig/releases/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fmod"

DEPEND=">=dev-cpp/ETL-0.04.22
	dev-cpp/gtkmm:3.0
	dev-cpp/libxmlpp
	dev-libs/libsigc++
	=media-gfx/synfig-${PV}
	fmod? ( media-libs/fmod )
	"
RDEPEND="${DEPEND}"

src_configure() {
	append-cxxflags -std=c++11
	econf \
		$(use_with fmod libfmod)
}
