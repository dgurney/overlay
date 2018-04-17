# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified by Daniel Gurney for his overlay
EAPI=6
inherit git-r3 autotools

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/about/"
EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"
LICENSE="GPL-2"
SLOT="0/4"
IUSE="selinux"

RDEPEND="
	sys-apps/util-linux
	selinux? ( sys-libs/libselinux )"
DEPEND="$RDEPEND"

PATCHES=( "${FILESDIR}"/${P}-fibmap-include-config_h.patch )

src_prepare() {
		default
		eautoreconf
}

src_configure() {
	#This is required to install to /sbin, bug #481110
	econf \
		--bindir="${EPREFIX}"/sbin \
		--disable-static \
		$(use_with selinux)
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
