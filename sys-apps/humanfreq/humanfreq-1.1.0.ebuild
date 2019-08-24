# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN=github.com/dgurney/${PN}
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

inherit golang-vcs-snapshot

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
}

src_install() {
	dobin bin/${PN}
	doman ${WORKDIR}/${P}/src/${EGO_PN}/man/${PN}.1
}

DESCRIPTION="Quick and dirty MHz scaling_cur_freq reader."
HOMEPAGE="https://github.com/dgurney/humanfreq"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

