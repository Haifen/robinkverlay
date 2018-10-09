# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.18"

inherit bash-completion-r1 check-reqs eutils gnome2-live meson multilib-minimal user systemd udev vala

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="http://www.freedesktop.org/software/colord/"
EGIT_REPO_URI="git://gitorious.org/colord/master.git"

LICENSE="GPL-2+"
SLOT="0/2" # subslot = libcolord soname version

# We prefer policykit enabled by default, bug #448058
IUSE="examples extra-print-profiles +introspection +policykit scanner systemd +udev vala"
REQUIRED_USE="
	scanner? ( udev )
	vala? ( introspection )
"
KEYWORDS=""
IUSE="${IUSE} doc"

COMMON_DEPEND="
	dev-db/sqlite:3=
	>=dev-libs/glib-2.36:2
	>=media-libs/lcms-2.6:2=
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )
	policykit? ( >=sys-auth/polkit-0.103 )
	scanner? ( media-gfx/sane-backends )
	systemd? ( >=sys-apps/systemd-44:0= )
	udev? (
		virtual/udev
		virtual/libgudev:=
		virtual/libudev:=
		)
"
RDEPEND="${COMMON_DEPEND}
	!media-gfx/shared-color-profiles
	!<=media-gfx/colorhug-client-0.1.13
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	extra-print-profiles? ( media-gfx/argyllcms )
	vala? ( $(vala_depend) )
	app-text/docbook-sgml-utils
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9 )
"

# FIXME: needs pre-installed dbus service files
RESTRICT="test"

# According to upstream comment in colord.spec.in, building the extra print
# profiles requires >=4G of memory
CHECKREQS_MEMORY="4G"

pkg_pretend() {
	use extra-print-profiles && check-reqs_pkg_pretend
}

pkg_setup() {
	use extra-print-profiles && check-reqs_pkg_setup
	enewgroup colord
	enewuser colord -1 -1 /var/lib/colord colord
}

src_prepare() {
	eapply_user
	# Adapt to Gentoo paths
	sed -i -e 's/spotread/argyll-spotread/' src/sensors/argyll/cd-sensor-argyll.c || die

	use vala && vala_src_prepare
	xdg_environment_reset
	gnome2_environment_reset
}

multilib_src_configure() {
	# bash-completion test does not work on gentoo
	local emesonargs=(
		-Denable-bash-completion=false
		-Denable-session-example=false
		-Ddefault-library-type=shared
		-Denable-libcolordcompat=true
		-Dwith-daemon-user=colord
		$(meson_use extra-print-profiles enable-print-profiles)
		$(meson_use scanner enable-sane)
		$(meson_use systemd enable-systemd)
		$(meson_use udev enable-udev-rules)
		$(meson_use vala enable_vala)
	)
	# parallel make fails in doc/api
	use doc && MAKEOPTS="${MAKEOPTS} -j1"
	meson_src_configure
}

multilib_src_install() {
	DESTDIR="${D}" eninja -C "${BUILD_DIR}" install
}

multilib_src_install_all() {
	DOCS="AUTHORS MAINTAINERS NEWS README.md"

	einstalldocs

	newbashcomp data/colormgr colormgr
	rm -vr "${ED}etc/bash_completion.d"

	# Ensure config and profile directories exist and /var/lib/colord/*
	# is writable by colord user
	keepdir /var/lib/color{,d}/icc
	fowners colord:colord /var/lib/colord{,/icc}

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi
}

