# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION=""
HOMEPAGE="https://github.com/GoogleCloudService/compute-image-packages"
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="dev-lang/python
		systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_install() {
	insinto /usr/share/google
	doins -r "${S}/usr/share/google/google_daemon"
	use systemd && systemd_dounit ${S}/usr/lib/systemd/system/google-{accounts,address,clock-sync}-manager.service
	einfo "Installing init services..."
	for gsn in {accounts,address,clock-sync}; do
		newinitd "${FILESDIR}/google-${gsn}-manager.initd" "google-${gsn}-manager"
	done
}

