# Copyright 2012-2014 W. Mark Kubacki, Vitaly Repin
# Distributed under the terms of the OSI Reciprocal Public License

EAPI="6"
inherit autotools multilib-minimal git-r3 flag-o-matic

LIBTOOL_PV="2.4"

DESCRIPTION="Data serialization and communication toolwork"
HOMEPAGE="http://thrift.apache.org/"
EGIT_REPO_URI="http://git-wip-us.apache.org/repos/asf/thrift.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+pic cpp c_glib csharp java erlang python perl php php_extension ruby haskell go"

RDEPEND=">=dev-libs/boost-1.40.0
	virtual/yacc
	sys-devel/flex
	dev-libs/openssl
	cpp? (
		>=sys-libs/zlib-1.2.3
		dev-libs/libevent
	)
	csharp? ( >=dev-lang/mono-1.2.4 )
	java? (
		>=virtual/jdk-1.5
		dev-java/ant
		dev-java/ant-ivy
		dev-java/commons-lang
		dev-java/slf4j-api
	)
	erlang? ( >=dev-lang/erlang-12.0.0 )
	python? (
		>=dev-lang/python-2.6.0
		!dev-python/thrift
	)
	perl? (
		dev-lang/perl
		dev-perl/Bit-Vector
		dev-perl/Class-Accessor
	)
	php? ( >=dev-lang/php-5.0.0 )
	php_extension? ( >=dev-lang/php-5.0.0 )
	ruby? ( virtual/rubygems )
	haskell? ( dev-haskell/haskell-platform )
	go? ( sys-devel/gcc[go] )
	"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.2[cxx]
	c_glib? ( dev-libs/glib )
	"

src_prepare() {
	eapply_user
	${S}/bootstrap.sh
}

multilib_src_configure() {
	local myconf
	for USEFLAG in ${IUSE}; do
		myconf+=" $(use_with ${USEFLAG/+/})"
	done

	# This flags either result in compilation errors
	# or byzantine runtime behaviour.
	filter-flags -fwhole-program -fwhopr

	ECONF_SOURCE="${S}" \
		econf \
		--enable-libtool-lock \
		${myconf}
}

multilib_src_compile() {
	emake || die "emake failed"
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

