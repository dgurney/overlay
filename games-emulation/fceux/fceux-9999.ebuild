# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# changes by Daniel Gurney for his overlay
EAPI=6
inherit autotools autotools git-r3 eutils scons-utils

DESCRIPTION="A portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="http://fceux.com/"
EGIT_REPO_URI="https://github.com/TASVideos/fceux/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+gtk logo +lua +opengl"

DEPEND="lua? ( dev-lang/lua:0 )
	media-libs/libsdl[opengl?,video]
	logo? ( media-libs/gd[png] )
	opengl? ( virtual/opengl )
	x11-libs/gtk+:3 
	sys-libs/zlib[minizip]"
RDEPEND=${DEPEND}

src_prepare()  {
		default
		eautoreconf
}

src_compile() {
escons \
		RELEASE=1 \
		DEBUG=0 \
		GTK=0 \
		CREATE_AVI=1 \
		SYSTEM_LUA=1 \
		SYSTEM_MINIZIP=1 \
		$(usex gtk GTK3=1 '') \
		$(usex logo LOGO=1 '') \
		$(usex !opengl OPENGL=0 '') \
		$(usex !lua LUA=0 '') 
		
}

src_install() {
	dobin bin/fceux
	doman documentation/fceux.6
	docompress -x /usr/share/doc/${PF}/documentation /usr/share/doc/${PF}/fceux.chm
	dodoc -r changelog.txt TODO-SDL bin/fceux.chm documentation
	rm -f "${D}/usr/share/doc/${PF}/documentation/fceux.6"
	make_desktop_entry fceux FCEUX
	doicon fceux.png
}
