#!/usr/bin/env bash 

set -e

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

get_lang()
{
	GENTOO_LANG=en
}

get_video_cards()
{
	VIDEO_CARDS="fbdev vesa"
	[[ "$(lsmod | grep -i i915)" ]] && VIDEO_CARDS="${VIDEO_CARDS} intel i915"
	[[ "$(lspci | grep -i nvidia)" ]] && VIDEO_CARDS="${VIDEO_CARDS} nvidia nouveau"
	[[ "$(lsmod | grep -i amdgpu)" ]] && VIDEO_CARDS="${VIDEO_CARDS} amdgpu"
	[[ "$(lsmod | grep -i radeon)" ]] && VIDEO_CARDS="${VIDEO_CARDS} radeon radeonsi"
	[[ "$(lsmod | grep -i iris)" ]] && VIDEO_CARDS="${VIDEO_CARDS} iris"
	return 0 # If "0" ins't returned, the program will crash
}

get_features()
{
	FEATURES="userfetch candy" # Candy feature is the best feature of portage
}

main()
{
	get_common_flags
	get_makeopts
	get_lang
	get_video_cards
	get_features
}
main

cat << EOF 
FEATURES="${FEATURES}"
COMMON_FLAGS="${COMMON_FLAGS}"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"
USE="${USE}"
MAKEOPTS="${MAKEOPTS}"

L10N="${GENTOO_LANG}"
VIDEO_CARDS="${VIDEO_CARDS}"
INPUT_DEVICES="libinput synaptics keyboard mouse evdev"

# Uncomment to enable quiet build
#EMERGE_DEFAULT_OPTS="\${EMERGE_DEFAULT_OPTS} --quiet-build=y"
EOF
