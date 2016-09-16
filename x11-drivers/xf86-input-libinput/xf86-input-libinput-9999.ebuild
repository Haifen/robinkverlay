# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 linux-info xorg-2

DESCRIPTION="X.org input driver based on libinput"

EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/driver/xf86-input-libinput"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libinput-1.3.0:0="
DEPEND="${RDEPEND}"

DOCS=( "README.md" "conf/40-libinput.conf" )

pkg_pretend() {
	CONFIG_CHECK="~TIMERFD"
	check_extra_config
}
