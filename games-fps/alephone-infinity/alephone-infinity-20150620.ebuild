# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Aleph One - Marathon Infinity"
HOMEPAGE="http://trilogyrelease.bungie.org/"
SRC_URI="https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${PV}/MarathonInfinity-${PV}-Data.zip
	mirror://gentoo/${PN}.png"

LICENSE="bungie-marathon"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="games-fps/alephone"
DEPEND="app-arch/unzip"

S=${WORKDIR}/Marathon\ Infinity

GAMES_DATADIR=/usr/share/games

src_prepare() {
	default
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry "alephone.sh infinity" "Aleph One - Marathon Infinity"

	# Make sure the extra dirs exist in case the user wants to add some data
	keepdir "${GAMES_DATADIR}"/${PN}/{Scripts,"Physics Models",Textures,Themes}

}

pkg_postinst() {
	elog "To play this scenario, run:"
	elog "alephone.sh infinity"
}

