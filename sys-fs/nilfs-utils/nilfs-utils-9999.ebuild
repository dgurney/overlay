# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib git-r3 linux-info autotools

DESCRIPTION="A New Implementation of a Log-structured File System for Linux"
HOMEPAGE="http://nilfs.sourceforge.net/"
EGIT_REPO_URI="https://github.com/nilfs-dev/nilfs-utils"
#EGIT_BRANCH="v2.2.y"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="static-libs"

RDEPEND="sys-libs/e2fsprogs-libs
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

CONFIG_CHECK="~POSIX_MQUEUE"

DOCS=( AUTHORS ChangeLog NEWS README )
src_prepare() {
		default
		eautoreconf
}
src_configure() {
	econf \
		$(use_enable static-libs static) \
		--libdir=/$(get_libdir) 
}

src_install() {
	default
	rm -f "${ED}"/$(get_libdir)/*.la || die
}
