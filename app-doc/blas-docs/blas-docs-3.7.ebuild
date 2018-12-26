# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="Documentation reference and man pages for blas implementations"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://rgcs.creosotehill.org/gentoo/distfiles/lapack-man-${PV}.tar.xz
	http://www.netlib.org/blas/blasqr.pdf
	http://www.netlib.org/blas/blast-forum/blas-report.pdf"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

S="${WORKDIR}/manpages"

src_install() {
	# rename because doman do not yet understand manl files
	# Not all systems have the rename command, like say FreeBSD
	local f t
	for f in blas/man/manl/*.l; do
		t="${f%%.l}.n"
		mv "${f}" "${t}"
	done
	doman blas/man/manl/*.n
	dodoc README "${DISTDIR}"/blas{-report,qr}.pdf
}

