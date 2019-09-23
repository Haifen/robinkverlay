# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.18"

inherit eutils git-r3 gnome2 meson vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/action/show/Apps/Terminal/VTE"

SRC_URI=""
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/vte.git/"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="+crypt debug doc fribidi glade gtk4 iconv +introspection vala"
KEYWORDS=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.8:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXft

	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	crypt?  ( >=net-libs/gnutls-3.2.7 )
"
RDEPEND="${RDEPEND}
	!x11-libs/vte:2.90[glade]
"

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		dev-libs/libxml2
		doc? ( >=dev-util/gtk-doc-1.13 )
	"
fi

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Ddocs=$(usex doc true false)
		-Dgir=$(usex introspection true false)
		-Dfribidi=$(usex fribidi true false)
		-Dgnutls=$(usex crypt true false)
		-Dgtk3=true
		-Dgtk4=$(usex gtk4 true false)
		-Diconv=$(usex iconv true false)
		-Dvapi=$(usex vala true false)
	)

	meson_src_configure
}

src_install() {
	DOCS="AUTHORS NEWS README.md"
	gnome2_src_install
	mv "${D}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}

