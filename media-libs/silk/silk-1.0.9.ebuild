# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mediastreamer-silk/mediastreamer-silk-0.0.1.ebuild,v 1.9 2013/06/29 19:23:39 ago Exp $

EAPI=5

inherit eutils flag-o-matic

MY_PN="SILK_SDK_SRC"

DESCRIPTION="SILK (skype codec) library"
HOMEPAGE="http://www.linphone.org"
SRC_URI="http://developer.skype.com/silk/${MY_PN}_v${PV}.zip"

LICENSE="Clear-BSD SILK-patent-license"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="bindist doc +pic utils"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_PN}_FIX_v${PV}"

RESTRICT="mirror" # silk license forbids distribution

pkg_setup() {
	use bindist && die "This package can't be redistributable due to SILK license."
}

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_configure() {
	use pic && append-cflags -fPIC
}

src_compile() {
	use utils && emake || emake lib
}

src_install() {
	# there is no make install
	dolib.a libSKP_SILK_SDK.a
	if use utils; then
		newbin decoder silk-decoder
		newbin encoder silk-encoder
		newbin signalcompare silk-signalcompare
	fi
	dodoc readme.txt
	use doc && dodoc doc/*.pdf
	insinto /usr/include/silk
	doins -r interface
}
