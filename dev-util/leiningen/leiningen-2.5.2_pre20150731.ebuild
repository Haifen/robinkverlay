
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4


DESCRIPTION="Leiningen is a build utility for clojure projects."
HOMEPAGE="http://github.com/technomancy/leiningen/"

private_script=false

MY_PV="${PV/_pre*/}"
RELEASEDATE="${PV/${MY_PV}_pre/}"
MY_JARPV="${MY_PV}-SNAPSHOT"
COMMIT_SHA1="2ea050fc67ad7afae839cb80f3e070bea41aeae6"
MYJARDEST="${PN}-${MY_JARPV}-${COMMIT_SHA1}-standalone.jar"


if [[ ${PV} =~ ^.+_pre[0-9]{8}$ ]]; then
	lein_url="http://rgcs.creosotehill.org/leiningen/snapshots/${MY_PV}/${RELEASEDATE}/${COMMIT_SHA1}/leiningen-${MY_JARPV}-standalone.jar -> ${MYJARDEST}"
	leinpkgre="s/^\(export\sLEIN_VERSION=\"${MY_JARPV}\)\(\"\)/\1-${COMMIT_SHA1}\2/"
	if [[ ${private_script} == true ]]; then
		leinpkg_url="http://rgcs.creosotehill.org/gentoo/distfiles/lein-pkg-${PV}"
	else
		leinpkg_url="https://raw.githubusercontent.com/technomancy/leiningen/${COMMIT_SHA1}/bin/lein-pkg -> lein-pkg-${PV}"
	fi
else
	if [[ ${private_script} == true ]]; then
		leinpkg_url="http://rgcs.creosotehill.org/gentoo/distfiles/lein-pkg-${PV}"
	else
		leinpkg_url="https://raw.githubusercontent.com/technomancy/leiningen/${COMMIT_SHA1}/bin/lein-pkg -> lein-pkg-${PV}"
	fi
	lein_url="https://github.com/technomancy/leiningen/releases/download/${PV}/leiningen-${PV}-standalone.jar"
fi

SRC_URI="${leinpkg_url} ${lein_url}"

RESTRICT="mirror"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

MY_P="${PN}${SLOT}-${PV}"

SITEFILE="70${PN}-gentoo.el"

S=${WORKDIR}/${MY_P}

src_unpack() {
	mkdir ${S}
	for f in ${A}; do
        cp /usr/portage/distfiles/${f} ${S}
	done
}

src_prepare() {
	[[ -v leinpkgre ]] && sed -ie "${leinpkgre}" "${S}/lein-pkg-${PV}"
}

src_install() {
    insinto /usr/bin
	newbin lein-pkg-${PV} lein

    mkdir -p ${D}/usr/share/java
	[[ -v COMMIT_SHA1 ]] && cp ${MYJARDEST} ${D}/usr/share/java/${MYJARDEST} || cp leiningen-${PV}-standalone.jar ${D}/usr/share/java/leiningen-${PV}-standalone.jar
}

