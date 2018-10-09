# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic git-r3

DESCRIPTION="library for making brushstrokes"
HOMEPAGE="https://github.com/mypaint/libmypaint"
EGIT_REPO_URI="https://github.com/mypaint/libmypaint.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gegl glib json openmp"

DEPEND="
	dev-lang/python
	dev-libs/glib
	dev-libs/json-c
	gegl? ( media-libs/gegl:0.3 )
	openmp? ( sys-devel/gcc[openmp] )
	"
RDEPEND="${DEPEND}
	!media-gfx/mypaint
	"
src_prepare() {
	eapply_user
	pushd "${S}"
	python2 generate.py mypaint-brush-settings-gen.h brushsettings-gen.h
	eautoreconf
}

src_configure() {
	local myconf=( )
	myconf+=( $(use_enable doc docs) $(use_enable gegl) $(use_with glib) $(use_enable openmp) )
	econf ${myconf[@]}
}

