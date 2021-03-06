# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified by Daniel Gurney for his overlay
EAPI=6

inherit autotools linux-info git-r3

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://hisham.hm/htop/"
EGIT_REPO_URI="https://github.com/hishamhm/htop"

LICENSE="BSD GPL-2"
SLOT="0"
IUSE="kernel_FreeBSD kernel_linux openvz unicode vserver"

RDEPEND="sys-libs/ncurses:0=[unicode?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

pkg_setup() {
	if ! has_version sys-process/lsof; then
		ewarn "To use lsof features in htop(what processes are accessing"
		ewarn "what files), you must have sys-process/lsof installed."
	fi

	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	local myeconfargs=(
		# fails to build against recent hwloc versions
		--disable-hwloc
		--enable-taskstats
		$(use_enable kernel_linux cgroup)
		$(use_enable kernel_linux linux-affinity)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable vserver)
	)
	econf ${myeconfargs[@]}
}
