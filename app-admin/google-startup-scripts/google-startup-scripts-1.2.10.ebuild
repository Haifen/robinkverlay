# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit systemd

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://github.com/GoogleCloudPlatform/compute-image-packages/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_install() {
	exeinto /usr/share/google
	doexe ${S}/usr/share/google/{fetch_script,first-boot,get_metadata_value,onboot,regenerate-host-keys,run-scripts,run-shutdown-scripts,run-startup-scripts,safe_format_and_mount,set-hostname,set-interrupts,virtionet-irq-affinity}
	exeinto /usr/share/google/boto
	doexe ${S}/usr/share/google/boto/boot_setup.py
	insinto /usr/share/google/boto/boto_plugins
	doins ${S}/usr/share/google/boto/boto_plugins/compute_auth.py
	newinitd ${FILESDIR}/google.initd google
	newinitd ${FILESDIR}/google-startup-scripts.initd google-startup-scripts
	if use systemd; then
		dounit ${S}/usr/lib/systemd/system/google.service
		dounit ${S}/usr/lib/systemd/system/google-startup-scripts.service
	fi
}

