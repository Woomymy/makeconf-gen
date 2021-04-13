#!/usr/bin/env bash 

set -e

MAKECONF_LANG="en"
USE="python"

red()
{
	echo -e "\e[91m${*}\e[m"
}

check_depend()
{
	[[ "$(command -v "${1}")" ]] || return 1
}

get_common_flags()
{
	# We use gcc to get -march option
	check_depend "gcc" ||
	{
		red "GCC not found!"
		exit 1
	}
	MARCH="$(gcc -v -E -x c -march=native -mtune=native - < /dev/null 2>&1 | grep cc1 | awk '{print $6}' | awk -F '=' '{print $2}')"
	COMMON_FLAGS="-march=${MARCH} -O2 -pipe" # -march=native is a solution but i will break distcc. See (https://wiki.gentoo.org/wiki/Distcc/#CFLAGS_et_CXXFLAGS)
	CFLAGS="${COMMON_FLAGS}"
	CXXFLAGS="${COMMON_FLAGS}"
}

get_makeopts()
{
	MAKEOPTS="-j$(( $(nproc) + 1))"
}

main()
{
	get_common_flags
	get_makeopts
}

main
