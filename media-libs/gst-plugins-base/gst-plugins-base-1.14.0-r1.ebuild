# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-base"

inherit flag-o-matic ltprune gstreamer

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="alsa +egl gles2 +introspection ivorbis +ogg +orc +opengl +pango theora +vorbis wayland X"
REQUIRED_USE="
	gles2? ( !opengl )
	opengl? ( X )
	ivorbis? ( ogg )
	theora? ( ogg )
	vorbis? ( ogg )
	wayland? ( egl )
	egl? ( || ( opengl gles2 ) )
"

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[introspection?,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	egl? ( >=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}] )
	gles2? ( >=media-libs/mesa-9.1.6[gles2,${MULTILIB_USEDEP}] )
	opengl? (
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}] )
	ivorbis? ( >=media-libs/tremor-0_pre20130223[${MULTILIB_USEDEP}] )
	ogg? ( >=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.24[${MULTILIB_USEDEP}] )
	pango? ( >=x11-libs/pango-1.36.3[${MULTILIB_USEDEP}] )
	theora? ( >=media-libs/libtheora-1.1.1[encode,${MULTILIB_USEDEP}] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1[${MULTILIB_USEDEP}] )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXv-1.0.10[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.4
	)
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	X? (
		>=x11-proto/videoproto-2.3.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}] )
"
RDEPEND+="!<media-libs/gst-plugins-bad-1.11.90:1.0" # rawparse move

multilib_src_configure() {
	filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340

	gstreamer_multilib_src_configure \
		$(use_enable alsa) \
		$(multilib_native_use_enable introspection) \
		$(use_enable ivorbis) \
		$(use_enable ogg) \
		$(use_enable egl) \
		$(use_enable gles2) \
		$(use_enable opengl) \
		$(use_enable opengl glx) \
		$(if [[ use opengl || use gles2 ]]; then
			echo --enable-gl
		fi) \
		$(use_enable orc) \
		$(use_enable pango) \
		$(use_enable theora) \
		$(use_enable vorbis) \
		$(use_enable wayland) \
		$(use_enable X x) \
		$(use_enable X xshm) \
		$(use_enable X xvideo) \
		--enable-iso-codes \
		--enable-zlib \
		--disable-debug \
		--disable-examples \
		--disable-static 
	# cdparanoia and libvisual are split out, per leio's request

	# bug #366931, flag-o-matic for the whole thing is overkill
	if [[ ${CHOST} == *86-*-darwin* ]] ; then
		sed -i \
			-e '/FLAGS = /s|-O[23]|-O1|g' \
			gst/audioconvert/Makefile \
			gst/volume/Makefile || die
	fi

	if multilib_is_native_abi; then
		local x
		for x in libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_install_all() {
	DOCS="AUTHORS NEWS README RELEASE"
	einstalldocs
	prune_libtool_files --modules
}
