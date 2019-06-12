# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Library for the Desktop Menu fd.o specification"
HOMEPAGE="https://git.gnome.org/browse/gnome-menus"

LICENSE="GPL-2+ LGPL-2+"
SLOT="3"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
fi

IUSE="debug +introspection test"

COMMON_DEPEND="
	>=dev-libs/glib-2.29.15:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
"
# Older versions of slot 0 install the menu editor and the desktop directories

RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-menus-3.0.1-r1:0
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/gjs )
"

src_prepare() {
	# Don't show KDE standalone settings desktop files in GNOME others menu
	eapply "${FILESDIR}/${PN}-3.22.0-ignore_kde_standalone.patch"

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	gnome2_src_configure \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable introspection) \
		--disable-static
}

