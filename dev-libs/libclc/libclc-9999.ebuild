# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit git-r3 llvm prefix python-any-r1 toolchain-funcs

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"
# libclc subdir of https://github.com/llvm/llvm-project.git
EGIT_REPO_URI="https://git.llvm.org/git/libclc.git/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE_VIDEO_CARDS="video_cards_nvidia video_cards_r600 video_cards_radeonsi"
IUSE="${IUSE_VIDEO_CARDS}"
REQUIRED_USE="|| ( ${IUSE_VIDEO_CARDS} )"

BDEPEND="
	|| (
		sys-devel/clang:10
		sys-devel/clang:9
		sys-devel/clang:8
	)
	${PYTHON_DEPS}"

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	default
	if use prefix; then
		hprefixify configure.py
	fi
}

pkg_setup() {
	# we do not need llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local libclc_targets=()

	use video_cards_nvidia && libclc_targets+=("nvptx--" "nvptx64--" "nvptx--nvidiacl" "nvptx64--nvidiacl")
	use video_cards_r600 && libclc_targets+=("r600--")
	use video_cards_radeonsi && libclc_targets+=("amdgcn--" "amdgcn-mesa-mesa3d")

	[[ ${#libclc_targets[@]} ]] || die "libclc target missing!"

	./configure.py \
		--with-cxx-compiler="$(tc-getCXX)" \
		--with-llvm-config="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config" \
		--prefix="${EPREFIX}/usr" \
		"${libclc_targets[@]}" || die
}

src_compile() {
	emake VERBOSE=1
}
