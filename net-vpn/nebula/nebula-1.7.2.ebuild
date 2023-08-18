# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd go-module

DESCRIPTION="Nebula VPN"
HOMEPAGE="https://github.com/slackhq/nebula"
SRC_URI="https://github.com/slackhq/nebula/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" http://moko.publicvm.com:13007/${P}-deps.tar.xz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"
IUSE="nebula-cert"
RDEPEND="acct-user/nebula"

src_prepare() {
    sed -i \
        -e "s|/usr/local/bin/nebula|${EPREFIX}/usr/bin/nebula|" \
        -e "s|/etc/nebula/config.yml|${EPREFIX}/etc/nebula/config.yml|" \
        -e '/^SyslogIdentifier*/a User=nebula\nGroup=nebula\nAmbientCapabilities=CAP_NET_ADMIN' \
        ${S}/examples/service_scripts/nebula.service || die "Patching systemd service file failed"
    sed \
        -e "s|EPREFIX|${EPREFIX}|g" "${FILESDIR}"/nebula > "${T}"/nebula || die "Setting EPREFIX in openrc service file failed"
    PATCHES+=" ${FILESDIR}/Makefile.patch"
    default
}

src_configure() {
    true
}

src_compile() {
    if use nebula-cert; then
        TOMAKE="bin"
    else
        TOMAKE="bin-nebula"
    fi
    make ${MAKEOPTS} ${TOMAKE}
}

src_install() {
    dobin nebula
    if use nebula-cert; then
        dobin nebula-cert
    fi
    doinitd "${T}"/nebula
    systemd_dounit examples/service_scripts/nebula.service
}
