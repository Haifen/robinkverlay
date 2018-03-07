# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

inherit eutils vala gnome2-live

DESCRIPTION="GTK support library for colord"
HOMEPAGE="http://www.freedesktop.org/software/colord/"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="git://gitorious.org/colord/colord-gtk.git"
else
	SRC_URI="http://www.freedesktop.org/software/colord/releases/${P}.tar.xz"
fi

LICENSE="LGPL-3+"
SLOT="0/1" # subslot = libcolord-gtk soname version
IUSE="doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"
KEYWORDS=""

COMMON_DEPEND="
	>=dev-libs/glib-2.28:2
	>=media-libs/lcms-2.2:2=
	x11-libs/gdk-pixbuf:2[introspection?]
	x11-libs/gtk+:3[X(+),introspection?]
	x11-misc/colord:=[introspection?,vala?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )"
# ${PN} was part of x11-misc/colord until 0.1.22
RDEPEND="${COMMON_DEPEND}
	!<x11-misc/colord-0.1.27
"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9
	)
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_install() {
	default
	prune_libtool_files --modules
}
