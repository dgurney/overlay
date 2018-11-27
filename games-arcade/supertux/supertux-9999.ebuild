# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified by Daniel Gurney for his overlay
EAPI=6
inherit git-r3 cmake-utils flag-o-matic gnome2-utils

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
inherit cmake-utils flag-o-matic

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="https://supertux.org/"

MY_P="supertux-9999"
EGIT_REPO_URI="https://github.com/SuperTux/supertux.git"

LICENSE="GPL-2+ GPL-3+ ZLIB MIT CC-BY-SA-2.0 CC-BY-SA-3.0"
SLOT="0"
IUSE="debug"

RDEPEND="dev-games/physfs
	dev-libs/boost:=
	media-libs/glew:=
	virtual/opengl
	media-libs/libvorbis
	media-libs/openal
	>=media-libs/libsdl2-2.0.1[joystick,video]
	>=media-libs/sdl2-image-2.0.0[png,jpeg]
	>=net-misc/curl-7.21.7"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DWERROR=OFF
		-DINSTALL_SUBDIR_BIN=bin
		-DINSTALL_SUBDIR_DOC=share/doc/${PF}
		-DINSTALL_SUBDIR_SHARE=share/${PN}2
		-DENABLE_SQDBG="$(usex debug)"
		-DENABLE_BOOST_STATIC_LIBS=OFF # bug! Please check if this is still required.
		-DUSE_SYSTEM_PHYSFS=ON
	)
	cmake-utils_src_configure
}
pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
