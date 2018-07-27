# Copyright 2012-2013 W-Mark Kubacki
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="6"

inherit eutils git-r3

DESCRIPTION="Tools for working with Chromium development. Needed for projects published by Google"
HOMEPAGE="https://dev.chromium.org/developers/how-tos/install-depot-tools"

EGIT_REPO_URI="https://chromium.googlesource.com/chromium/tools/depot_tools.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE=""
RESTRICT="strip binchecks"

DEPEND="sys-apps/grep
	dev-vcs/git
	>=sys-devel/gcc-4.1.0[cxx]
	>=dev-lang/python-2.6.0[threads]
	dev-util/gperf"

S="${WORKDIR}/depot_tools"

src_install() {
	insinto /usr/bin/${PN/-/_}
	doins -r "${S}"/*

	for F in $(grep -rlF '#!' *); do
		fperms 0755 /usr/bin/${PN/-/_}/${F}
	done

	newenvd "${FILESDIR}"/depot-tools.envd 99depot-tools
}
