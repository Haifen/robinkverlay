# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic git-r3

DESCRIPTION="Open source SIP, Media, and NAT Traversal Library"
HOMEPAGE="http://www.pjsip.org/"
SRC_URI="http://www.pjsip.org/release/${PV}/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
CODEC_FLAGS="g711 g722 g7221 gsm ilbc speex l16"
VIDEO_FLAGS="sdl ffmpeg v4l2 openh264 libyuv"
SOUND_FLAGS="alsa oss portaudio"
IUSE="amr debug doc epoll examples ipv6 opus resample ring silk ssl static-libs webrtc ${CODEC_FLAGS} ${VIDEO_FLAGS} ${SOUND_FLAGS}"

RDEPEND="alsa? ( media-libs/alsa-lib )
	oss? ( media-libs/portaudio[oss] )
	portaudio? ( media-libs/portaudio )

	amr? ( media-libs/opencore-amr )
	gsm? ( media-sound/gsm )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	ssl? ( dev-libs/openssl )

	ffmpeg? ( virtual/ffmpeg:= )
	sdl? ( media-libs/libsdl )
	openh264? ( media-libs/openh264 )
	resample? ( media-libs/libsamplerate )

	net-libs/libsrtp"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="?? ( ${SOUND_FLAGS} )"

src_unpack() {
	default
	# IMO this should live in ${FILESDIR}, but ah well.
	if use ring; then
		EGIT_REPO_URI="https://gerrit-ring.saviorfairelinux.com/ring-daemon" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/ring" \
		git-r3_src_unpack
	fi
}

src_prepare() {
	if use ring; then
		# This is ugly.  Consider making a rebased patch quilt or something.
		eapply "${WORKDIR}/ring/contrib/src/pjproject/*.patch" \
			"${FILESDIR}/pjsip-ring-intptr_t.patch"
		sed -i -e 's#/usr/local#/usr#' aconfigure
	fi
	eapply_user
}

src_configure() {
	local myconf=()
	local videnable="--disable-video"
	local t
	local ssl
	if use ring; then
		use ssl && ssl=--enable-ssl=gnutls
		conf=./aconfigure
	else
		use ssl && ssl=$(use_enable ssl)
		conf=econf
	fi

	use ipv6 && append-flags -DPJ_HAS_IPV6=1
	use debug || append-flags -DNDEBUG=1

	for t in ${CODEC_FLAGS}; do
		myconf+=( $(use_enable ${t} ${t}-codec) )
	done

	for t in ${VIDEO_FLAGS}; do
		myconf+=( $(use_enable ${t}) )
		use "${t}" && videnable="--enable-video"
	done

	$conf \
		--enable-shared \
		--with-external-srtp \
		${videnable} \
		$(use_enable epoll) \
		$(use_with gsm external-gsm) \
		$(use_with speex external-speex) \
		$(use_enable speex speex-aec) \
		$(use_enable resample) \
		$(use_enable resample libsamplerate) \
		$(use_enable resample resample-dll) \
		$(use_enable alsa sound) \
		$(use_enable oss) \
		$(use_with portaudio external-pa) \
		$(use_enable portaudio ext-sound) \
		$(use_enable amr opencore-amr) \
		$(use_enable silk) \
		$(use_enable opus) \
		$(use_enable webrtc) \
		"${myconf[@]}"
}

src_compile() {
	emake dep
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		dodoc README.txt README-RTEMS
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r pjsip-apps/src/samples
	fi

	use static-libs || rm "${D}/usr/$(get_libdir)/*.a"
}
