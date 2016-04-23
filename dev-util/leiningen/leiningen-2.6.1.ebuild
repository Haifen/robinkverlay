
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Leiningen is a build utility for clojure projects."
HOMEPAGE="http://github.com/technomancy/leiningen/"

private_script=false

if [[ ${private_script} == true ]]; then
	leinpkg_url="http://rgcs.creosotehill.org/gentoo/distfiles/lein-pkg-${PV}"
else
	leinpkg_url="https://raw.githubusercontent.com/technomancy/leiningen/${PV}/bin/lein-pkg	-> lein-pkg-${PV}"
fi

SRC_URI="${leinpkg_url}
https://github.com/technomancy/leiningen/releases/download/${PV}/${P}-standalone.zip -> ${P}-standalone.jar"
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

src_install() {
    insinto /usr/bin
	newbin lein-pkg-${PV} lein

    mkdir -p ${D}/usr/share/java
	cp leiningen-${PV}-standalone.jar ${D}/usr/share/java/leiningen-${PV}-standalone.jar
}

