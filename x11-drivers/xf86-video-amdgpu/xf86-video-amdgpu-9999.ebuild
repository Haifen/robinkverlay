# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 linux-info xorg-2

DESCRIPTION="AMD GPU X11 driver"
HOMEPAGE="http://cgit.freedesktop.org/xorg/driver/xf86-video-amdgpu/log/?h=master"
EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/driver/xf86-video-amdgpu"

SLOT="0"
KEYWORDS="~amd64"
IUSE="+glamor udev"

DEPEND="x11-libs/libdrm[video_cards_amdgpu]
		glamor? ( ||
					( x11-base/xorg-server[glamor]
					  >=x11-libs/glamor-0.6.0 ) )
		udev? ( virtual/udev )"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 19; then
			CONFIG_CHECK="~DRM_AMDGPU ~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_AMDGPU ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
							$(use_enable glamor)
							$(use_enable udev) )
	xorg-2_src_configure
}

