EAPI=6

inherit git-r3 meson

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
EGIT_REPO_URI="https://github.com/PipeWire/pipewire"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="gstreamer man docs"

RDEPEND="media-libs/libv4l
         sys-apps/dbus
         virtual/udev
         gstreamer? (
             media-libs/gstreamer:1.0
             media-libs/gst-plugins-base:1.0
         )"
DEPEND="${RDEPEND}
        docs? ( app-doc/doxygen )
        man? ( app-doc/xmltoman )"

src_configure() {
	local emesonargs=(
		-Denable_gstreamer=$(usex gstreamer true false)
		-Denable_man=$(usex man true false)
		-Denable_docs=$(usex docs true false)
	)
	meson_src_configure
}
