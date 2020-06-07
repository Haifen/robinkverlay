# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
XORG_EAUTORECONF="yes"
XORG_MULTILIB="yes"

if [[ ${PV} =~ 9999 ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
	EGIT_REPO_URI="git://github.com/xkbcommon/${PN}"
else
	XORG_BASE_INDIVIDUAL_URI=""
	SRC_URI="http://xkbcommon.org/download/${P}.tar.xz"
fi

inherit ${GIT_ECLASS} meson multilib-minimal

DESCRIPTION="X.Org xkbcommon library"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="X doc test wayland"
SLOT="0"

DEPEND="sys-devel/bison
	sys-devel/flex
	X? ( >=x11-libs/libxcb-1.10[${MULTILIB_USEDEP},xkb] )
	>=x11-base/xorg-proto-2020.1
	doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	einfo "Munging docdir to match Gentoo's path standard…"
	sed -i -r -e "s/(docdir\s\=.+)\)$/\1 + '-${PV}'))/" ${S}/meson.build
	eapply_user
}

multilib_src_configure() {
	emesonargs=(
		-Dxkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		-Denable-x11="$(usex X true false)"
		-Denable-docs="$(usex doc true false)"
		-Denable-wayland="$(usex wayland true false)"
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

