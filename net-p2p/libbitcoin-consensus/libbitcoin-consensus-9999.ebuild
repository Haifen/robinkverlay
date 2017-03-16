# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit autotools git-r3 java-pkg-2 multilib-minimal python-r1

DESCRIPTION="libbitcoin consensus library"
HOMEPAGE="https://github.com/libbitcoin/libbitcoin-consensus"
EGIT_REPO_URI="git://github.com/libbitcoin/libbitcoin-consensus"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug java python"

DEPEND=">=dev-libs/boost-1.56.0
		dev-libs/libsecp256k1
		java? ( || ( dev-java/icedtea dev-java/oracle-jdk-bin ) )
		python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

multilib_src_configure() {
	local myconf=( )
	myconf+=( $(use_with java) )
	myconf+=( $(use_with python) )
	myconf+=( $(use_with !debug ndebug) )
	ECONF_SOURCE="${S}" econf ${myconf[@]}
}

