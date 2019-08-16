# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3 meson udev

DESCRIPTION="Library to handle input devices in Wayland"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libinput/"
EGIT_REPO_URI="https://gitlab.freedesktop.org/libinput/libinput.git/"

LICENSE="MIT"
SLOT="0/10"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc debug input_devices_wacom test"
# Tests require write access to udev rules directory which is a no-no for live system.
# Other tests are just about logs, exported symbols and autotest of the test library.
RESTRICT="test"

RDEPEND="
	input_devices_wacom? ( >=dev-libs/libwacom-0.12 )
	>=dev-libs/libevdev-0.4
	>=sys-libs/mtdev-1.1
	virtual/libudev
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
#	test? (
#		>=dev-libs/check-0.9.10
#		dev-util/valgrind
#		sys-libs/libunwind )

src_configure() {
	# gui can be built but will not be installed
	# building documentation silently fails with graphviz syntax errors
	local emesonargs=(
		"-Ddocumentation=$(usex doc true false)"
		"-Ddebug-gui=$(usex debug true false)"
		"-Dlibwacom=$(usex input_devices_wacom true false)"
		"-Dtests=$(usex test true false)"
		"-Dudev-dir=$(get_udevdir)" )
	meson_src_configure
}

