-- dependencies/imgui_vesk.lua
-- IMGUI LIB PREMAKE --


project "ImGui"
	location "imgui_vesk"

	kind "StaticLib"
	language "C++"

	targetdir ( "%{prj.location}/bin/"       .. outputdir )
	objdir    ( "%{prj.location}/bin_inter/" .. outputdir )


	local srcdir = "imgui_vesk/"

	includedirs {
		srcdir,
		srcdir .. "misc/freetype/",

		"freetype/include/"
	}

	files {
		srcdir .. "imconfig.h",
		srcdir .. "imgui.h",
		srcdir .. "imgui.cpp",
		srcdir .. "imgui_draw.cpp",
		srcdir .. "imgui_internal.h",
		srcdir .. "imgui_tables.cpp",
		srcdir .. "imgui_widgets.cpp",
		srcdir .. "imstb_rectpack.h",
		srcdir .. "imstb_textedit.h",
		srcdir .. "imstb_truetype.h",
		srcdir .. "imgui_demo.cpp",

		srcdir .. "misc/freetype/imgui_freetype.cpp",
		srcdir .. "misc/freetype/imgui_freetype.h"
	}

	links { "freetype/freetype.lib" }


	filter "system:windows"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"

	filter "system:linux"
		pic "On"
		systemversion "latest"
		cppdialect "C++17"
		staticruntime "On"

	filter "configurations:Debug"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		runtime "Release"
		optimize "on"