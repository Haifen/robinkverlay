# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

# This is excessive and arguably unnessecary, but I want to let WAF/Clasp play
# outside the sandbox, and I also don't want to cripple Clasp's
# stack-frame-reporting system.
RESTRICT="splitdebug strip test userpriv usersandbox"

PYTHON_COMPAT=( python3_4 python3_5 python3_6 python3_7 )
PYTHON_REQ_USE="+threads"

inherit flag-o-matic git-r3 multilib python-r1

DESCRIPTION="Common Lisp implementation targetting LLVM 6"
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

# This function shouldn't normally be called, but I need a way to test
# iclasp-boehm's behavior
iclasp_boehm_test() {
	einfo "Firing up iclasp-boehm to see how it behaves..."
	strace "${S}/build/boehm/iclasp-boehm -t -b" |& \
		tee "${T}/iclasp_boehm_strace_$(date +%s).log"
}

pkg_setup() {
	python_setup
}

src_unpack() {
	git-r3_src_unpack
	cd ${S}
	# Bluhhh, this bit is ugly, but it should work (I want nested arrays)
	# Also, doing prepare/configure work in src_unpack (doubly ugly)
	einfo "Copying wscript.config from wscript.config.template..."
	cp wscript.config.template wscript.config
	einfo "Munging wscript.config to point LLVM_CONFIG_BINARY to:\n/usr/lib/llvm/6/bin/llvm-config ..."
	sed -i -e "s:\#\\s\\(LLVM_CONFIG_BINARY = '\\).*\\('\\):\\1/usr/lib/llvm/6/bin/llvm-config\\2:" wscript.config
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
		sed -i -e "s:\\(DEBUG_OPTIONS.+\\)\\s\\(\"DEBUG_RELEASE.+\\):\\1\#\\2:" wscript.config
		sed -i -e "s:\\s\\(\\s+\"DEBUG_BCLASP_LISP\",\\):\#\\1:" wscript.config
		sed -i -e "s:\\s\\(\\s+\"DEBUG_BCLASP_LISP\",\\):\#\\1:" wscript.config
		sed -i -e "s:\\s\\(\\s+\"DEBUG_CCLASP_LISP\",\\):\#\\1:" wscript.config
		sed -i -e "s:\\s\\(\\s+\"DEBUG_SLOW\",\\):\#\\1:" wscript.config
	fi
	eapply "${FILESDIR}/clasp-9999-wscript-record-repo-urls.patch"
	${S}/waf configure
	egms=$(<${S}/.egitmodules)
	egsubmodules=(${egms[@]})
	for sru in egsubmodules; do
		_IFS="${IFS}"
		IFS=";"
		sr=( ${sru[@]} )
		IFS="${_IFS}"
		unset _IFS
		git-r3_fetch ${sr[0]} ${sr[1]}
		git-r3_checkout ${sr[0]} ${S}/${sr[2]}
	done
}

src_prepare() {
	cd "${S}"
	eapply_user
}

src_configure() {
	einfo "Clasp was \"configured\" in the src_unpack phase, NOOP here..."
}

src_compile() {
	"${S}/waf" build_cboehm
}

src_install() {
	"${S}/waf" install_cboehm --destdir="${D}"
}

