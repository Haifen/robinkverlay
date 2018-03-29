# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer

DESCRIPTION="GStreamer Kernel Modesetting plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-bad-plugins/html/gst-plugins-bad-plugins-kmssink.html"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/gstreamer-1.14.0"
RDEPEND="${DEPEND}"
