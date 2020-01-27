EAPI=6

inherit git-r3 meson

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
EGIT_REPO_URI="https://github.com/PipeWire/pipewire"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE_PIPEWIRE_SPA_PLUGINS="pipewire_spa_plugins_alsa
						   pipewire_spa_plugins_audioconvert
						   pipewire_spa_plugins_audiomixer
						   pipewire_spa_plugins_audiotestsrc
						   pipewire_spa_plugins_bluetooth
						   pipewire_spa_plugins_control
						   pipewire_spa_plugins_ffmpeg
						   pipewire_spa_plugins_jack
						   pipewire_spa_plugins_support
						   pipewire_spa_plugins_v4l2
						   pipewire_spa_plugins_videoconvert
						   pipewire_spa_plugins_videotestsrc
						   pipewire_spa_plugins_volume
						   pipewire_spa_plugins_vulkan"
IUSE="alsa bluetooth doc ffmpeg gstreamer jack pulseaudio systemd ${IUSE_PIPEWIRE_SPA_PLUGINS}"

RDEPEND="sys-apps/dbus
		 virtual/udev
		 alsa? ( media-libs/alsa-lib )
		 pipewire_spa_plugins_alsa? ( media-libs/alsa-lib )
		 pipewire_spa_plugins_bluetooth? ( || ( >=net-wireless/bluez-4.101
								  				media-libs/sbc
												sys-apps/dbus ) )
		 pipewire_spa_plugins_ffmpeg? ( ||
										( media-video/ffmpeg
										  media-video/libav ) )
         gstreamer? (
             media-libs/gstreamer:1.0
             media-libs/gst-plugins-base:1.0
         )
		 jack? ( >=media-sound/jack2-1.9.10 )
		 pipewire_spa_plugins_jack? ( >=media-sound/jack2-1.9.10 )
		 pulseaudio? ( >=media-sound/pulseaudio-11.1 )
		 pipewire_spa_plugins_support? ( sys-apps/dbus )
		 systemd? ( sys-apps/systemd )
		 pipewire_spa_plugins_vulkan? ( media-libs/vulkan-loader )"
DEPEND="${RDEPEND}
        doc? ( app-doc/doxygen )
        app-doc/xmltoman"

src_prepare() {
	einfo "Patching doc/meson.build to place docs in Gentoo-compatible directory."
	sed -i -e "s/\(docdir\,\s'\)pipewire.*\('\)/\1${P}\2/g" "${S}/doc/meson.build"
	default
}

src_configure() {
	local emesonargs=(
		-Dpipewire-alsa=$(usex alsa true false)
		-Ddocs=$(usex doc true false)
		-Dgstreamer=$(usex gstreamer true false)
		-Dpipewire-jack=$(usex jack true false)
		-Dman=true
		-Dpipewire-pulseaudio=$(usex pulseaudio true false)
		-Dspa-plugins=true
		-Dalsa=$(usex pipewire_spa_plugins_alsa true false)
		-Daudioconvert=$(usex pipewire_spa_plugins_audioconvert true false)
		-Daudiomixer=$(usex pipewire_spa_plugins_audiomixer true false)
		-Daudiotestsrc=$(usex pipewire_spa_plugins_audiotestsrc true false)
		-Dbluez5=$(usex pipewire_spa_plugins_bluetooth true false)
		-Dcontrol=$(usex pipewire_spa_plugins_control true false)
		-Dffmpeg=$(usex pipewire_spa_plugins_ffmpeg true false)
		-Djack=$(usex pipewire_spa_plugins_jack true false)
		-Dsupport=$(usex pipewire_spa_plugins_support true false)
		-Dv4l2=$(usex pipewire_spa_plugins_v4l2 true false)
		-Dvideoconvert=$(usex pipewire_spa_plugins_videoconvert true false)
		-Dvideotestsrc=$(usex pipewire_spa_plugins_videotestsrc true false)
		-Dvolume=$(usex pipewire_spa_plugins_volume true false)
		-Dvulkan=$(usex pipewire_spa_plugins_vulkan true false)
		-Dsystemd=$(usex systemd true false)
	)
	meson_src_configure
}

