# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools subversion

DESCRIPTION="Interface for GDB to Atmel AVR JTAGICE in circuit emulator"
HOMEPAGE="http://avarice.sourceforge.net/"
ESVN_REPO_URI="svn://svn.code.sf.net/p/avarice/code/trunk/avarice"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="AUTHORS ChangeLog doc/*.txt"

src_prepare() {
		eapply_user
		eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake install DESTDIR=${D}
}

