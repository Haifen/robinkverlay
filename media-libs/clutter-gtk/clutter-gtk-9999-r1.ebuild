# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2-live meson

DESCRIPTION="Library for embedding a Clutter canvas (stage) in GTK+"
HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
LICENSE="LGPL-2.1+"

SLOT="1.0"
KEYWORDS=""
IUSE="${IUSE} doc"
IUSE="X doc examples gtk introspection wayland"

RDEPEND="
	>=x11-libs/gtk+-3.8.0:3[X=,introspection,wayland=]
	>=media-libs/clutter-1.23.7:1.0[X=,gtk=,introspection,wayland=]
	media-libs/cogl:1.0=[introspection]
	>=dev-libs/gobject-introspection-0.9.12:=
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"
src_prepare() {
	eapply_user
	xdg_environment_reset
	gnome2_environment_reset
}

src_configure() {
	local emesonconf=( 
		$(meson_use doc enable_docs)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.c,redhand.png}
	fi
}
