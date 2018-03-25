# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer

DESCRIPTION="Alliance for Open Media AV1 Codec support for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libaom
		>=media-libs/gstreamer-1.14.0"
RDEPEND="${DEPEND}"
