EAPI=6

inherit meson

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
SRC_URI="https://github.com/PipeWire/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

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
		-Dgstreamer=$(usex gstreamer true false)
		-Dman=true
		-Dsystemd=$(usex systemd true false)
	)
	meson_src_configure
}
