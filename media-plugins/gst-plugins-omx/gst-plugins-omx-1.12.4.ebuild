# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-libav/gst-plugins-libav-1.2.0.ebuild,v 1.3 2014/01/21 21:56:59 eva Exp $

EAPI="6"

inherit flag-o-matic meson multilib-minimal

MY_PN="gst-omx"
DESCRIPTION="GStreamer OpenMAX IL wrapper plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-omx.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~arm"
IUSE="bellagio rpi"

# FIXME: What >=media-libs/gst-plugins-bad-1.4.0:1.0[gl] stuff for non-rpi?
RDEPEND="
	>=media-libs/gstreamer-1.12.0:1.0
	>=media-libs/gst-plugins-base-1.12.0:1.0
	rpi? (
		media-libs/raspberrypi-userland
		>=media-libs/gst-plugins-bad-1.12.0:1.0[egl,gles2,rpi]
	)
	bellagio? (
		media-libs/libomxil-bellagio
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.3
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	local emesonargs=()
	if use rpi; then
		emesonargs+="-Dwith_omx_target=$(usex rpi rpi none) -Dwith-omx-header-path=/opt/vc/include/IL"
	fi
	if use bellagio; then
		emesonargs+="-Dwith-omx-target=$(usex bellagio bellagio none)"
	fi
	if ! use rpi && ! use bellagio; then
		emesonargs+="-Dwith-omx-target=generic"
	fi
	meson_src_configure
	sed -e 's/^(.*GST_PACKAGE_NAME\s+").+(".*)$/\1Gentoo GStreamer ebuild\2' -i -r ${S}/config.h
	sed -e 's/^(.*GST_PACKAGE_ORIGIN\s+").+(".*)$/\1https://www.gentoo.org\2' -i -r ${S}/config.h
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}

