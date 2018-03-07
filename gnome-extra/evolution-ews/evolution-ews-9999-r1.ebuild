# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils gnome2 gnome2-live git-r3

DESCRIPTION="Evolution module for connecting to Microsoft Exchange Web Services"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

LICENSE="LGPL-2.1"
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi
IUSE="test"

RDEPEND="
	dev-db/sqlite:3=
	>=dev-libs/glib-2.40:2
	dev-libs/libical:0=
	>=dev-libs/libxml2-2
	>=gnome-extra/evolution-data-server-${PV}:0=
	>=mail-client/evolution-${PV}:2.0
	>=net-libs/libsoup-2.42:2.4
	>=x11-libs/gtk+-3:3
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35.5
	virtual/pkgconfig
	test? ( net-libs/uhttpmock )
"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	eapply_user
	xdg_src_prepare
	gnome2_environment_reset
}

src_configure() {
	# We don't have libmspack, needing internal lzx
	local mycmakeargs=( -DWITH_MSPACK=on -DENABLE_TESTS=$(usex test) )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}

