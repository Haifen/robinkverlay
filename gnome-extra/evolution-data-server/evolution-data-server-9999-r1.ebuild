# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )
VALA_USE_DEPEND="vapigen"

inherit db-use flag-o-matic gnome2 python-any-r1 vala virtualx
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"

# Note: explicitly "|| ( LGPL-2 LGPL-3 )", not "LGPL-2+".
LICENSE="|| ( LGPL-2 LGPL-3 ) BSD Sleepycat"
SLOT="0/57" # subslot = libcamel-1.2 soname + optional revision if needed

IUSE="api-doc-extras +berkdb +gnome-online-accounts +gtk +google +introspection ipv6 ldap kerberos vala +weather"
REQUIRED_USE="vala? ( introspection )"

if [[ ${PV} = 9999 ]]; then
	IUSE="${IUSE} doc"
	REQUIRED_USE="${REQUIRED_USE} api-doc-extras? ( doc )"
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
fi

# sys-libs/db is only required for migrating from <3.13 versions
# gdata-0.15.1 is required for google tasks
# berkdb needed only for migrating old calendar data, bug #519512
RDEPEND="
	>=app-crypt/gcr-3.4
	>=app-crypt/libsecret-0.5[crypt]
	>=dev-db/sqlite-3.7.17:=
	>=dev-libs/glib-2.40:2
	>=dev-libs/libgdata-0.10:=
	>=dev-libs/libical-0.43:=
	>=dev-libs/libxml2-2
	>=dev-libs/nspr-4.4:=
	>=dev-libs/nss-3.9:=
	>=net-libs/libsoup-2.42:2.4

	dev-libs/icu:=
	sys-libs/zlib:=
	virtual/libiconv

	berkdb? ( >=sys-libs/db-4:= )
	gtk? (
		>=app-crypt/gcr-3.4[gtk]
		>=x11-libs/gtk+-3.10:3
	)
	google? (
		>=dev-libs/json-glib-1.0.4
		>=dev-libs/libgdata-0.15.1:=
		>=net-libs/webkit-gtk-2.4.9:3
	)
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.8 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	kerberos? ( virtual/krb5:= )
	ldap? ( >=net-nds/openldap-2:= )
	weather? ( >=dev-libs/libgweather-3.10:2= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/gperf
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

# eautoreconf needs:
#	>=gnome-base/gnome-common-2

if [[ ${PV} = 9999 ]]; then
	DEPEND="${DEPEND}
		doc? ( >=dev-util/gtk-doc-1.14 )
	"
fi

S="${WORKDIR}/evolution-data-server-9999"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	use vala && vala_src_prepare

	# Fix relink issues in src_install
	ELTCONF="--reverse-deps"

	eapply_user
	[[ -e ChangeLog ]] || touch ChangeLog
	xdg_src_prepare
	eautoreconf
	elibtoolize ${ELTCONF}

	# Fix compilation flags crazyness, upstream bug #653157
	sed 's/^\(AM_CFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure || die "sed failed"
}

src_configure() {
	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	use berkdb && append-cppflags "-I$(db_includedir)"

	# phonenumber does not exist in tree
	gnome2_src_configure \
		$(use_enable api-doc-extras gtk-doc) \
		$(use_with api-doc-extras private-docs) \
		$(usex berkdb --with-libdb="${EPREFIX}"/usr --with-libdb=no) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable gtk) \
		$(use_enable google google-auth) \
		$(use_enable google) \
		$(use_enable introspection) \
		$(use_enable ipv6) \
		$(use_with kerberos krb5 "${EPREFIX}"/usr) \
		$(use_with kerberos krb5-libs "${EPREFIX}"/usr/$(get_libdir)) \
		$(use_with ldap openldap) \
		$(use_enable vala vala-bindings) \
		$(use_enable weather) \
		--enable-largefile \
		--enable-smime \
		--without-phonenumber \
		--disable-examples \
		--disable-uoa
}

src_test() {
	unset ORBIT_SOCKETDIR
	unset SESSION_MANAGER
	unset DISPLAY
	Xemake check
}

src_install() {
	gnome2_src_install

	if use ldap; then
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema
		dosym /usr/share/${PN}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst
	if ! use berkdb; then
		ewarn "You will need to enable berkdb USE for migrating old"
		ewarn "(pre-3.12 evolution versions) addressbook data"
	fi
}