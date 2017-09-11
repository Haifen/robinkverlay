# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic git-r3 waf-utils

LLVM_MAX_SLOT="5"

DESCRIPTION="Common LISP implementation targetting LLVM 5"
HOMEPAGE="https://github.com/drmeister/clasp/wiki"
EGIT_REPO_URI="git://github.com/drmeister/clasp
			   https://github.com/drmeister/clasp"
EGIT_BRANCH="dev"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~ppc"
IUSE=""

DEPEND="sys-devel/llvm:5
		sys-devel/clang:5
		sys-devel/binutils
		dev-libs/boehm-gc
		dev-libs/gmp:0
		app-arch/bzip2
		sys-libs/zlib
		dev-libs/expat
		dev-libs/boost
		sys-devel/flex
		net-libs/zeromq"
RDEPEND="${DEPEND}"

pkg_setup() {
	append-flags "-mcmodel=medium"
	llvm_pkg_setup
}

src_prepare() {
	cd "${S}"
	cp "wscript.config{.template,}"
	sed -i -e "s/\(LLVM_CONFIG_BINARY = '\).*\('\)/\1$(get_llvm_prefix 5)\2/" wscript.config
}

src_compile() {
	cd "${S}"
	./waf build_cboehm
}

src_install() {
	into /usr/bin
	newbin ${S}/build/boehm/iclasp-boehm clasp
}

