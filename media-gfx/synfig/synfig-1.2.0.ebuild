# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base flag-o-matic

DESCRIPTION="Synfig core engine and libraries"
HOMEPAGE="http://www.synfig.org/"
SRC_URI="mirror://sourceforge/synfig/releases/${PV}/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dv ffmpeg fontconfig imagemagick jpeg openexr truetype"

DEPEND=">=dev-cpp/ETL-0.04.22
	dev-cpp/libxmlpp
	dev-libs/libsigc++
	media-libs/mlt
	dv? ( media-libs/libdv )
	openexr? ( media-libs/openexr )
	truetype? ( media-libs/freetype )
	fontconfig? ( media-libs/fontconfig )
	ffmpeg? ( virtual/ffmpeg )
	jpeg? ( virtual/jpeg )
	imagemagick? ( media-gfx/imagemagick )"
RDEPEND="${DEPEND}"

src_configure() {
	append-cxxflags -std=c++11
	econf \
		$(use_with dv libdv) \
		$(use_with ffmpeg) \
		$(use_with fontconfig) \
		$(use_with imagemagick) \
		$(use_with jpeg) \
		$(use_with openexr) \
		$(use_with truetype freetype)
}
