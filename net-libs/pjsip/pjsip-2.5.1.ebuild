# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Multimedia communication libraries written in C language
for building VoIP applications."
HOMEPAGE="http://www.pjsip.org/"
SRC_URI="http://www.pjsip.org/release/${PV}/pjproject-${PV}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa amr doc epoll examples ext-sound ffmpeg g711 g722 g7221 gsm ilbc ipv6 l16 libyuv openh264 oss python resample small-filter large-filter opus silk sound speex srtp static-libs sdl ssl v3l2 video webrtc"

DEPEND="virtual/pkgconfig
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	gsm? ( media-sound/gsm )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	openh264? ( media-libs/openh264 )
	opus? ( media-libs/opus )
	resample? ( media-libs/libsamplerate )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	srtp? ( net-libs/libsrtp )
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/pjproject-${PV}"

src_configure() {
	local myconf=()

	if ( use sdl || use v4l2 || use ffmpeg || use libyuv || use openh264 ) && ! use video; then
		die "sdl, v4l2, ffmpeg, libyuv and openh264 require USE flag 'video'. Bailing out."
	fi

	if ! use ilbc; then
		myconf+=( --disable-ilbc-codec )
	fi

	if ! use openh264; then
                myconf+=( --disable-openh264 )
        fi

	if ! use srtp; then
		myconf+=( --with-external-srtp )
	fi

	if ! use ssl; then
		myconf+=( --disable-ssl )
	fi

	use ipv6 && append-flags -DPJ_HAS_IPV6=1

	econf \
		--enable-shared \
		$(use_enable silk) \
		$(use_enable sound) \
		$(use_enable resample) \
		$(use_enable resample libsamplerate) \
		$(use_enable amr opencore-amr) \
		$(use_enable epoll) \
		$(use_enable alsa sound) \
		$(use_enable gsm gsm-codec) \
		$(use_with gsm external-gsm) \
		$(use_enable oss) \
		$(use_enable ext-sound) \
		$(use_enable libyuv) \
		$(use_enable sdl) \
		$(use_enable speex speex-aec) \
		$(use_enable speex speex-codec) \
		$(use_with speex  external-speex) \
		$(use_enable g711 g711-codec) \
		$(use_enable l16 l16-codec) \
		$(use_enable g722 g722-codec) \
		$(use_enable g7221 g7221-codec) \
		$(use_enable v4l2) \
		$(use_enable video) \
		$(use_enable small-filter) \
		$(use_enable large-filter) \
		$(use_enable ffmpeg) \
		$(use_enable webrtc) \
		"${myconf[@]}" \
		|| die "econf failed."
}

src_compile() {
	emake dep || die "emake dep failed"
	emake || die "emake failed"
}

src_install() {
	DESTDIR="${D}" emake install || die "emake install failed."

	if use python; then
		pushd pjsip-apps/src/python
		python setup.py install --prefix="${D}/usr/"
		popd
	fi

	if use doc; then
		dodoc README.txt README-RTEMS
	fi

	if use examples; then
		insinto "/usr/share/doc/${P}/examples"
		doins "${S}/pjsip-apps/src/samples/"*
	fi

        # Remove static library if needed
        use static-libs || rm -f "${D}"/usr/lib*/lib*.a
}
