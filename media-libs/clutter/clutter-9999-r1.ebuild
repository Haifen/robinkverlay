# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit git-r3 meson virtualx

HOMEPAGE="https://wiki.gnome.org/Projects/Clutter"
DESCRIPTION="Clutter is a library for creating graphical user interfaces"

LICENSE="LGPL-2.1+ FDL-1.1+"
SLOT="1.0"
IUSE="aqua debug doc egl gtk +introspection test wayland X"
REQUIRED_USE="
	|| ( aqua wayland X )
	wayland? ( egl )
"
KEYWORDS=""

# NOTE: glx flavour uses libdrm + >=mesa-7.3
# >=libX11-1.3.1 needed for X Generic Event support
# do not depend on tslib, it does not build and is disable by default upstream
RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/atk-2.5.3[introspection?]
	>=dev-libs/json-glib-0.12[introspection?]
	>=media-libs/cogl-1.21.2:1.0=[introspection?,pango,wayland?]
	>=x11-libs/cairo-1.14:=[aqua?,glib]
	>=x11-libs/pango-1.30[introspection?]

	virtual/opengl
	x11-libs/libdrm:=

	egl? (
		>=dev-libs/libinput-0.19.0
		media-libs/cogl:1.0=[gles2,kms]
		>=virtual/libgudev-136
		x11-libs/libxkbcommon
	)
	gtk? ( >=x11-libs/gtk+-3.3.18:3[aqua?] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	X? (
		media-libs/fontconfig
		>=x11-libs/libX11-1.3.1
		x11-libs/libXext
		x11-libs/libXdamage
		x11-proto/inputproto
		>=x11-libs/libXi-1.3
		>=x11-libs/libXcomposite-0.4 )
	wayland? (
		dev-libs/wayland
		x11-libs/gdk-pixbuf:2 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		>=dev-util/gtk-doc-1.20
		>=app-text/docbook-sgml-utils-0.6.14[jadetex]
		dev-libs/libxslt )
	test? ( x11-libs/gdk-pixbuf )
"

src_prepare() {
	# We only need conformance tests, the rest are useless for us
	sed -e 'd/.\+\(interactive\)\?\(micro-bench\)\?\(performance\)\?.\+/' \
		-i tests/meson.build || die "meson tests sed failed"
	default
}

src_configure() {
	# XXX: Conformance test suite (and clutter itself) does not work under Xvfb
	# (GLX error blabla)
	# XXX: coverage disabled for now
	# XXX: What about cex100/win32 backends?
	local emesonargs=( "-Dbackends=$(usex aqua quartz, "")$(usex egl eglnative, "")$(usex gtk gdk, "")$(usex wayland wayland, "")$(usex x11 x11 "")" \
		"-Ddocumentation=$(usex doc true false)" \
		"-Dintrospection=$(usex introspection true false)" \
		"-Dpixbuf_tests=$(usex test true false)" )
	meson_src_configure
}

src_test() {
	ninja -C tests/conform check
}
