# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit git-r3 meson

DESCRIPTION="Session / policy manager implementation for PipeWire"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/wireplumber"
EGIT_REPO_URI="https://gitlab.freedesktop.org/pipewire/wireplumber.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc introspection +system-lua"

DEPEND="dev-libs/glib:2
		>=media-video/pipewire-0.3
		doc? ( app-doc/hotdoc )
		introspection? ( dev-libs/gobject-introspection )
		system-lua? ( dev-lang/lua:5.3 )"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=( -Dintrospection=$(usex introspection enabled disabled)
	-Ddoc=$(usex doc enabled disabled) -Dsystem-lua=$(usex system-lua true false) )
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}

