# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit git-r3 python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Support library for mypaint, also known as libbrush"
HOMEPAGE="https://github.com/mypaint/libmypaint"
EGIT_REPO_URI="git://github.com/mypaint/libmypaint"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gegl glib i18n introspection openmp static-libs"

DEPEND="dev-libs/json-c
		dev-util/scons
		${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
		# Call sphinx-build instead of sphinx-build2
		sed -i -e 's/sphinx-build2/sphinx-build/' "${S}/doc/SConscript"
		eapply_user
}

multilib_src_configure() {
	MYSCONS=(
			prefix="${D}/usr/" # Scons sucks, but libmypaint SConstruct sucks more
			CC="$(tc-getCC)"
			enable_i18n="$(usex i18n True False)"
			enable_introspection="$(usex introspection True False)"
			enable_docs="$(usex doc True False)"
			enable_openmp="$(usex openmp True False)"
			use_glib="$(usex glib True False)"
	)
}

src_compile() {
		escons "${MYSCONS[@]}"
}

src_install() {
		escons "${MYSCONS[@]}" install
}

