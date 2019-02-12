EAPI=6

inherit git-r3 meson

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
EGIT_REPO_URI="https://github.com/PipeWire/pipewire"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="gstreamer doc systemd"

RDEPEND="media-libs/libv4l
         sys-apps/dbus
         virtual/udev
         gstreamer? (
             media-libs/gstreamer:1.0
             media-libs/gst-plugins-base:1.0
         )
		 systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
        doc? ( app-doc/doxygen )
        app-doc/xmltoman"

src_configure() {
	local emesonargs=(
		-Ddocs=$(usex doc true false)
		-Dgstreamer=$(usex gstreamer enabled disabled)
		-Dman=true
		-Dsystemd=$(usex systemd true false)
	)
	meson_src_configure
}
