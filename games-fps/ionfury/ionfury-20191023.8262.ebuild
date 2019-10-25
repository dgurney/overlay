# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs xdg-utils

MY_BUILD="$(ver_cut 2)"
MY_DATE="$(ver_cut 1)"

DESCRIPTION="Eduke32 built for Ion Fury"
HOMEPAGE="http://www.eduke32.com/"
SRC_URI="http://dukeworld.com/eduke32/synthesis/${MY_DATE}-${MY_BUILD}/eduke32_src_${MY_DATE}-${MY_BUILD}.tar.xz"

LICENSE="BUILDLIC GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="flac gtk opengl png vorbis vpx"
REQUIRED_USE="
	vpx? ( opengl )
"

S="${WORKDIR}/eduke32_${MY_DATE}-${MY_BUILD}"

RDEPEND="
	media-libs/libsdl2[joystick,opengl?,sound,video]
	media-libs/sdl2-mixer[flac?,vorbis?]
	sys-libs/zlib:=
	flac? ( media-libs/flac )
	gtk? ( x11-libs/gtk+:2 )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	png? ( media-libs/libpng:0= )
	vpx? ( media-libs/libvpx:= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/ionfury-search.patch"
)

src_unpack() {
	# Extract only the eduke32 archive
	unpack eduke32_src_${MY_DATE}-${MY_BUILD}.tar.xz
}

src_compile() {
	local myemakeopts=(
		ALLOCACHE_AS_MALLOC=0
		AS=$(tc-getAS)
		CC=$(tc-getCC)
		CXX=$(tc-getCXX)
		CLANG=0
		CPLUSPLUS=1
		CUSTOMOPT=""
		DEBUGANYWAY=0
		F_JUMP_TABLES=""
		FORCEDEBUG=0
		FURY=1
		HAVE_FLAC=$(usex flac 1 0)
		HAVE_GTK2=$(usex gtk 1 0)
		HAVE_VORBIS=$(usex vorbis 1 0)
		HAVE_XMP=1 # Who wants to disable music?!
		LINKED_GTK=$(usex gtk 1 0)
		LTO=1
		LUNATIC=0
		KRANDDEBUG=0
		MEMMAP=0
		MIXERTYPE=SDL
		OPTLEVEL=0
		OPTOPT=""
		PACKAGE_REPOSITORY=1
		POLYMER=0 # Ion Fury does not properly support Polymer.
		PRETTY_OUTPUT=0
		PROFILER=0
		RELEASE=1
		RENDERTYPE=SDL
		SDL_TARGET=2
		SIMPLE_MENU=0
		STRIP=""
		STANDALONE=0
		STARTUP_WINDOW=$(usex gtk 1 0)
		USE_OPENGL=$(usex opengl 1 0)
		USE_LIBVPX=$(usex vpx 1 0)
		USE_LIBPNG=$(usex png 1 0)
		USE_LUAJIT_2_1=0
		WITHOUT_GTK=$(usex gtk 0 1)
	)

	emake "${myemakeopts[@]}"
}

src_test() {
	# There are no tests
	# Instead it tries to build a test game, which does not compile
	:;
}

src_install() {
	dobin fury
	make_desktop_entry fury "Ion Fury"
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	elog "Place the Ion Fury data files to /usr/share/ionfury or /usr/share/games/ionfury."
}

pkg_postrm() {
	xdg_icon_cache_update
}
