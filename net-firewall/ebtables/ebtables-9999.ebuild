# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/ebtables/ebtables-2.0.10.4.ebuild,v 1.5 2014/08/10 20:55:27 slyfox Exp $

EAPI="6"

inherit autotools git-r3 versionator toolchain-funcs multilib flag-o-matic

DESCRIPTION="Utility that enables basic Ethernet frame filtering on a Linux bridge, MAC NAT and brouting"
HOMEPAGE="http://ebtables.sourceforge.net/"
EGIT_REPO_URI="git://git.netfilter.org/ebtables"


KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static"
LICENSE="GPL-2"
SLOT="0"

pkg_setup() {
	if use static; then
		ewarn "You've chosen static build which is useful for embedded devices."
		ewarn "It has no init script. Make sure that's really what you want."
	fi
}

src_prepare() {
	eapply_user
	# Enhance ebtables-save to take table names as parameters bug #189315
	eapply "${FILESDIR}/${PN}-2.0.8.1-ebt-save.diff"

	# Allow multi-line MAC/IP files for --among-src-file and --among-dst-file
	eapply "${FILESDIR}/${PN}-2.0.10.4-ebt_among.c.patch"
	# Fix ebtables output with custom chains, to fix ebtables-{save,restore}
	eapply "${FILESDIR}/${PN}-2.0.10.4-ebt_standard.c.patch"

	sed -i -e 's/^\(EBTD_ARGC_MAX\s\?=\).\+/\1 2048/' -e 's/^\(EBTD_CMDLINE_MAXLN\s\?=\).\+/\1 131072/' Makefile.am

	eautoreconf
}

src_configure() {
	econf --sbindir=/sbin
}

src_compile() {
	# This package uses _init functions to initialise extensions. With
	# --as-needed this will not work.
	append-ldflags $(no-as-needed)
	# This package correctly aliases pointers, but gcc is unable to know that:
	# unsigned char ip[4];
	# if (*((uint32_t*)ip) == 0) {
	#append-cflags -Wno-strict-aliasing
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		$(use static && echo static)
}

src_install() {
	if ! use static; then
		make DESTDIR="${D}" install
		keepdir /var/lib/ebtables/
		newinitd "${FILESDIR}"/ebtables.initd-r1 ebtables
		newconfd "${FILESDIR}"/ebtables.confd-r1 ebtables
	else
		into /
		newsbin static ebtables
		insinto /etc
		doins ethertypes
	fi
	dodoc ChangeLog
}

