# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_4 python3_5 python3_6 python3_7 )
PYTHON_REQ_USE="+threads"

inherit flag-o-matic git-r3 multilib python-r1

DESCRIPTION="Common LISP implementation targetting LLVM 6"
HOMEPAGE="https://github.com/clasp-developers/clasp/wiki"
EGIT_REPO_URI="https://github.com/clasp-developers/clasp"
EGIT_BRANCH="dev"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~ppc"
IUSE="debug"

DEPEND="sys-devel/llvm:6
		sys-devel/clang:6
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

CC="clang"
CXX="clang++"

pkg_setup() {
	llvm_pkg_setup
	python_setup
}

src_prepare() {
	cd "${S}"
	einfo "Copying wscript.config from wscript.config.template..."
	cp wscript.config.template wscript.config
	einfo "Munging wscript.config to point LLVM_CONFIG_BINARY to:\n$(get_llvm_prefix 6)/bin/llvm-config ..."
	sed -i -e "s:\\(LLVM_CONFIG_BINARY = '\\).*\\('\\):\\1$(get_llvm_prefix 6)/bin/llvm-config\\2:" wscript.config
	einfo "Munging wscript.config to install to /usr"
	sed -i -e "s:\\(PREFIX = '\\).*\\('\\):\\1${EPREFIX}/usr\\2:" wscript.config
	if has_version dev-libs/boehm-gc[handle-fork]; then
		einfo "The Boehm GC looks like it can handle forking, leaving parallel build"
		einfo "enabled..."
	else
		einfo "The Boehm GC doesn't seem to be built with --enable-handle-fork,"
		einfo "disabling parallel build..."
		sed -i -e "s:\\(USE_PARALLEL_BUILD = \\).*:\\1False:" wscript.config
	fi
	if use debug; then
		einfo "Leaving default debug enablements alone..."
	else
		einfo "Disabling extra debugging features (DEBUG_CCLASP_LISP is still on)."
		sed -i -e "s::\\(DEBUG_OPTIONS.+\\)\\s\\(\"DEBUG_RELEASE.+\\):\1\#\2:" wscript.config
		sed -i -e "s::\\s\\(\\s+\"DEBUG_BCLASP_LISP\",\\):\#\1:" wscript.config
		sed -i -e "s::\\s\\(\\s+\"DEBUG_BCLASP_LISP\",\\):\#\1:" wscript.config
		sed -i -e "s::\\s\\(\\s+\"DEBUG_SLOW\",\\):\#\1:" wscript.config
	fi
	eapply_user
}

src_configure() {
	einfo "Running Clasp-specific automated build prep..."
	"${S}/waf" configure		# Submodules have already been fetched
								# and checked out, this just sets up
								# some stuff for the build
}

src_compile() {
	"${S}/waf" build_cboehm
}

src_install() {
	"${S}/waf" install_cboehm --destdir="${D}"
}

