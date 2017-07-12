# media-libs/vulkan-base-9999.ebuild

EAPI=6

inherit flag-o-matic git-r3

DESCRIPTION="Official Vulkan headerfiles, loader, validation layers and sample binaries"
HOMEPAGE="https://vulkan.lunarg.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers.git"

LICENSE="MIT"
IUSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86 ~arm ~arm64"

DEPEND="dev-util/cmake
	>=dev-lang/python-3"

src_unpack() {
	git-r3_fetch "https://github.com/KhronosGroup/glslang.git"
	git-r3_fetch "https://github.com/KhronosGroup/SPIRV-Tools.git"
	git-r3_fetch "https://github.com/KhronosGroup/SPIRV-Headers.git"
	git-r3_fetch ${EGIT_REPO_URI}

	git-r3_checkout https://github.com/KhronosGroup/glslang.git \
		"${S}"/glslang
	git-r3_checkout https://github.com/KhronosGroup/SPIRV-Tools.git \
		"${S}"/spirv-tools
	git-r3_checkout https://github.com/KhronosGroup/SPIRV-Headers.git \
		"${S}"/spirv-tools/external/spirv-headers
	git-r3_checkout ${EGIT_REPO_URI} "${S}"/sdk
}

src_compile() {
	append-cflags "-Wno-error=implicit-fallthrough"
	append-cxxflags "-Wno-error=implicit-fallthrough"
	einfo "Building glslang"
	cd "${S}"/glslang
	cmake -DCMAKE_INSTALL_PREFIX="${D}" -H. -Bbuild
	cd "${S}"/glslang/build
	emake || die "cannot build glslang"
	make install || die "cannot install glslang"

	einfo "Building SPIRV-Tools"
	cd "${S}"/spirv-tools
	cmake -DCMAKE_INSTALL_PREFIX="${D}" -H. -Bbuild
	cd "${S}"/spirv-tools/build
	emake || die "cannot build SPIRV-Tools"

	cd "${S}"/sdk
	cmake	\
		-DCMAKE_INSTALL_PREFIX="${D}" \
		-DBUILD_WSI_XCB_SUPPORT=ON	\
		-DBUILD_WSI_XLIB_SUPPORT=ON	\
		-DBUILD_WSI_WAYLAND_SUPPORT=OFF	\
		-DBUILD_WSI_MIR_SUPPORT=OFF	\
		-DBUILD_VKJSON=OFF		\
		-DBUILD_LOADER=ON		\
		-DBUILD_LAYERS=ON		\
		-DBUILD_DEMOS=OFF		\
		-DBUILD_TESTS=OFF		\
		-DSPIRV_TOOLS_LIB=${S}/spirv-tools/build/tools \
		-DGLSLANG_VALIDATOR=${S}/glslang/build/install/bin/glslangValidator	\
		-H. -Bbuild
	cd "${S}"/sdk/build
	emake || die "cannot build Vulkan Loader"
}

# TODO -DBUILD_DEMOS and dobin for demos should be invoked by examples use flag, in
# case something is broken in demos like right now
#       mkdir -p "${D}"/usr/share/vulkan/demos/{cube,tri,smoke}
src_install() {
	mkdir -p "${D}"/{etc,usr/share}/vulkan/{icd.d,implicit_layer.d,explicit_layer.d}
	mkdir -p "${D}"/usr/$(get_libdir)/vulkan
	mkdir -p "${D}"/usr/{bin,include}
	mkdir -p "${D}"/etc/env.d

	# prefix the tri and cube examples
	#mv "${S}"/sdk/build/demos/cube "${S}"/sdk/build/demos/vulkancube
	#mv "${S}"/sdk/build/demos/tri "${S}"/sdk/build/demos/vulkantri
	#cp -a "${S}"/sdk/build/demos/cube* "${D}"/usr/share/vulkan/demos/cube
	#cp -a "${S}"/sdk/demos/cube.{c,vert,frag} "${D}"/usr/share/vulkan/demos/cube
	#cp -a "${S}"/sdk/demos/lunarg.ppm "${D}"/usr/share/vulkan/demos/cube
	#cp -a "${S}"/sdk/build/demos/tri* "${D}"/usr/share/vulkan/demos/tri
	#cp -a "${S}"/sdk/demos/tri.{c,vert,frag} "${D}"/usr/share/vulkan/demos/tri
	#cp -a "${S}"/sdk/build/demos/smoketest "${D}"/usr/share/vulkan/demos/smoke
	#dobin "${S}"/sdk/build/demos/vulkan{info,cube,tri}
	#dobin "${S}"/sdk/build/demos/vulkaninfo
	#dobin "${S}"/spirv-tools/build/tools/spirv-*

	# header files
	cp -R "${S}"/sdk/include/vulkan "${D}"/usr/include
	cp -R "${S}"/spirv-tools/external/spirv-headers/include/spirv "${D}"/usr/include

	# vulkan loader lib
	dolib.so "${S}"/sdk/build/loader/lib*.so*

	# vulkan validation layers
	exeinto /usr/$(get_libdir)/vulkan
	doexe "${S}"/sdk/build/layers/libVk*.so*

	# layer json files
	sed -i -e 's#./libVk#libVk#g' "${S}"/sdk/layers/linux/*.json
	insinto /usr/share/vulkan/explicit_layer.d
	doins "${S}"/sdk/layers/linux/*.json

	dodoc "${S}"/sdk/LICENSE.txt

	find "${D}" -executable -type f -exec chrpath -d '{}' \;

	# point linker to newly created vulkan layer libs
	cat << EOF > "${D}"/etc/env.d/89vulkan
LDPATH="/usr/$(get_libdir)/vulkan;"
EOF
}

pkg_postinst() {
	env-update
}
