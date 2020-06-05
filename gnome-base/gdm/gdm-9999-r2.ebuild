# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_LA_PUNT="yes"

inherit eutils gnome2-live meson pam readme.gentoo-r1 systemd user

DESCRIPTION="GNOME Display Manager for managing graphical display servers and user logins"
HOMEPAGE="https://wiki.gnome.org/Projects/GDM"

SRC_URI="${SRC_URI}
	branding? ( http://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )
"

LICENSE="
	GPL-2+
	branding? ( CC-BY-SA-4.0 )
"

SLOT="0"

IUSE="accessibility audit branding fprint +introspection ipv6 plymouth profiling selinux smartcard systemd tcpd test wayland xinerama xdmcp"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"

# NOTE: x11-base/xorg-server dep is for X_SERVER_PATH etc, bug #295686
# nspr used by smartcard extension
# dconf, dbus and g-s-d are needed at install time for dconf update
# We need either systemd or >=openrc-0.12 to restart gdm properly, bug #463784
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.58.0:2[dbus]
	>=x11-libs/gtk+-2.91.1:3
	>=gnome-base/dconf-0.20
	>=gnome-base/gnome-settings-daemon-3.30.0
	>=gnome-base/gsettings-desktop-schemas-3.28.1
	>=media-libs/fontconfig-2.5.0:1.0
	>=media-libs/libcanberra-0.4[gtk3]
	sys-apps/dbus
	>=sys-apps/accountsservice-0.6.12

	x11-apps/sessreg
	x11-base/xorg-server
	x11-libs/libXi
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libxcb
	>=x11-misc/xdg-utils-1.0.2-r3

	sys-libs/pam
	>=sys-apps/systemd-186:0=[pam]

	sys-auth/pambase[systemd]

	audit? ( sys-process/audit )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	plymouth? ( sys-boot/plymouth )
	selinux? ( sys-libs/libselinux )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	xinerama? ( x11-libs/libXinerama )
"
# XXX: These deps are from session and desktop files in data/ directory
# fprintd is used via dbus by gdm-fingerprint-extension
# gnome-session-3.6 needed to avoid freezing with orca
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-session-3.6
	>=gnome-base/gnome-shell-3.1.90
	x11-apps/xhost

	accessibility? (
		>=app-accessibility/orca-3.10
		gnome-extra/mousetweaks )
	fprint? (
		sys-auth/fprintd
		sys-auth/pam_fprint )

	!gnome-extra/fast-user-switch-applet
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.40.0
	dev-util/itstool
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( >=dev-libs/check-0.9.4 )
"

DOC_CONTENTS="
	To make GDM start at boot, run:\n
	# systemctl enable gdm.service\n
	\n
	For passwordless login to unlock your keyring, you need to install
	sys-auth/pambase with USE=gnome-keyring and set an empty password
	on your keyring. Use app-crypt/seahorse for that.\n
	\n
	You may need to install app-crypt/coolkey and sys-auth/pam_pkcs11
	for smartcard support
"

pkg_setup() {
	enewgroup gdm
	enewgroup video # Just in case it hasn't been created yet
	enewuser gdm -1 -1 /var/lib/gdm gdm,video

	# For compatibility with certain versions of nvidia-drivers, etc., need to
	# ensure that gdm user is in the video group
	if ! egetent group video | grep -q gdm; then
		# FIXME XXX: is this at all portable, ldap-safe, etc.?
		# XXX: egetent does not have a 1-argument form, so we can't use it to
		# get the list of gdm's groups
		local g=$(groups gdm)
		elog "Adding user gdm to video group"
		usermod -G video,${g// /,} gdm || die "Adding user gdm to video group failed"
	fi
}

src_prepare() {
	gnome2-live_src_prepare
}

src_configure() {
	local emesonargs=(
			-Dat-spi-registryd-dir="${EPREFIX}"/usr/libexec
			-Dcheck-accelerated-dir="${EPREFIX}"/usr/libexec
			-Ddbus-sys="${EPREFIX}"/etc/dbus-1/systemd.d
			-Ddefault-pam-config=exherbo
			-Ddefaults-conf="${EPREFIX}"/etc/gdm/defaults.conf
			-Ddmconfdir=/etc/gdm
			-Dgdm-xsession=true
			-Dgnome-settings-daemon-dir="${EPREFIX}"/usr/libexec
			-Dinitial-vt=1
			-Dipv6=$(usex ipv6 true false)
			-Dlang-file=/etc/locale.conf
			-Dlibaudit=$(usex audit enabled disabled)
			-Dlog-dir="${EPREFIX}"/var/log/gdm
			-Dpam-mod-dir=$(getpam_mod_dir)
			-Dpam-prefix="${EPREFIX}"/etc/pam.d
			-Dpid-file=/var/run/gdm.pid
			-Dplymouth=$(usex plymouth enabled disabled)
			-Dprofiling=$(usex profiling true false)
			-Dran-once-marker-dir="${EPREFIX}"/var/run
			-Drun-dir=/run/gdm
			-Druntime-conf="${EPREFIX}"/etc/gdm/custom.conf
			-Dscreenshot-dir="${EPREFIX}"/var/lib/gdm/screenshots
			-Dselinux=$(usex selinux enabled disabled)
			-Dsplit-authentication=true
			-Dsysconfsubdir=gdm
			-Dsystemd-journal=$(usex systemd true false)
			-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
			-Dtcp-wrappers=$(usex tcpd true false)
			-Dudev-dir="$(get_udevdir)"/rules.d
			-Duser=gdm
			-Duser-display-server=true
			-Dwayland-support=$(usex wayland true false)
			-Dworking-dir="${EPREFIX}"/var/lib/gdm
			-Dxauth-dir="${EPREFIX}"/var/lib/gdm
			-Dxdmcp=$(usex xdmcp enabled disabled) )
	meson_src_configure

}

src_install() {
	gnome2_src_install

	if ! use accessibility ; then
		rm "${ED}"/usr/share/gdm/greeter/autostart/orca-autostart.desktop || die
	fi

	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}/49-keychain-r1" 49-keychain
	newexe "${FILESDIR}/50-ssh-agent-r1" 50-ssh-agent

	# gdm user's home directory
	keepdir /var/lib/gdm
	fowners gdm:gdm /var/lib/gdm

	# install XDG_DATA_DIRS gdm changes
	echo 'XDG_DATA_DIRS="/usr/share/gdm"' > 99xdg-gdm
	doenvd 99xdg-gdm

	use branding && newicon "${WORKDIR}/tango-gentoo-v1.1/scalable/gentoo.svg" gentoo-gdm.svg

	readme.gentoo_create_doc
}

pkg_postinst() {
	local d ret

	gnome2_pkg_postinst

	# bug #436456; gdm crashes if /var/lib/gdm subdirs are not owned by gdm:gdm
	ret=0
	ebegin "Fixing "${EROOT}"var/lib/gdm ownership"
	chown gdm:gdm "${EROOT}var/lib/gdm" || ret=1
	for d in "${EROOT}var/lib/gdm/"{.cache,.config,.local}; do
		[[ ! -e "${d}" ]] || chown -R gdm:gdm "${d}" || ret=1
	done
	eend ${ret}

	readme.gentoo_print_elog
}
