# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 toolchain-funcs

EGIT_REPO_URI="git://github.com/graphitemaster/gmqcc.git"

DESCRIPTION="An Improved Quake C Compiler"
HOMEPAGE="http://graphitemaster.github.com/gmqcc/"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/graphitemaster/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	tc-export CC
}

src_compile() {
	make_targets=( "qmqcc" )
	use qcvm && make_targets+=( "qcvm" )
	emake ${make_targets[@]}
}

src_install() {
	dobin gmqcc
	use qcvm && dobin qcvm
	doman doc/gmqcc.1
	use qvcm && doman doc/qvcm.1
	dodoc README AUTHORS TODO CHANGES
}

