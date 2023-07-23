# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Nebula VPN"
HOMEPAGE="https://github.com/slackhq/nebula"
SRC_URI="https://github.com/slackhq/nebula/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror network-sandbox"
PATCHES="${FILESDIR}/nebula-service.patch"
BDEPEND="dev-lang/go"

src_prepare() {
    if [[ "${CBUILD}" == *"x86_64"* ]]; then
        PATCHES+=( "${FILESDIR}"/linux-amd64.patch )
    fi
    if [[ "${CBUILD}" == *"aarch64"* ]]; then
        PATCHES+=( "${FILESDIR}"/linux-aarch64.patch )
    fi
    default
}

src_configure() {
    true
}

src_compile() {
    make release-linux
}

src_install() {
    if [[ "${CBUILD}" == *"x86_64"* ]]; then
        BUILDPATH="linux-amd64"
    fi
    if [[ "${CBUILD}" == *"aarch64"* ]]; then
        BUILDPATH="linux-arm64"
    fi
    dobin build/${BUILDPATH}/nebula
    dobin build/${BUILDPATH}/nebula-cert
    doinitd "${FILESDIR}"/nebula
    systemd_dounit examples/service_scripts/nebula.service
}
