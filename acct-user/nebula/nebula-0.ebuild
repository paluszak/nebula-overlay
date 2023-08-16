# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-vpn/nebula"

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( nebula )

acct-user_add_deps
