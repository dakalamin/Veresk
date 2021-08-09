-- /premake5.lua
-- VERESK APP PREMAKE --


workspace "Veresk"
	architecture "x86_64"
	startproject "Veresk"

	configurations { "Debug", "Release" }
	

	root      = "%{wks.location}/"
	outputdir = "%{cfg.buildcfg}-%{cfg.system}"

	local srcdir   = root .. "source"
	local incdir   = root .. "include"
	local depsdir  = root .. "dependencies"

	local builddir = root .. "\\BUILD\\" .. outputdir


	-- Virtual folder to contain several projects
	group "DEPENDENCIES"
		include "dependencies/glfw.lua"
		include "dependencies/glad.lua"
		include "dependencies/imgui_vesk.lua"
		-- 'glm' does not require compilation, it's header only
		-- 'freetype' does not require compilation, it has a compiled lib & is used only inside imgui_vesk
	group ""


	flags {
		"FatalWarnings",		 -- Treat all warnings as errors
		"MultiProcessorCompile"  -- Enable VS to use multiple compiler processes when building
	}


	project "Veresk"
		targetname "Veresk App"  -- Name of executable
		kind "ConsoleApp"		 -- Kind of binary object being created by project (https://premake.github.io/docs/kind/)
		language "C++"
		cppdialect "C++latest"
		staticruntime "off"	

		dependson {
			"GLFW",
			"Glad",
			"ImGui"
		}


		targetdir (root .. "bin/"       .. outputdir)  -- Destination directory for compiled binary target
		objdir    (root .. "bin_inter/" .. outputdir)  -- Destination directory for object and other intermediate files

		-- Include file search paths for the compiler
		includedirs {
			srcdir,
			incdir,

			depsdir .. "/glfw/include",
			depsdir .. "/glad/include",
			depsdir .. "/imgui_vesk",
			depsdir .. "/glm"
		}

		files {
			srcdir  .. "/**.h",
			srcdir  .. "/**.hpp",
			srcdir  .. "/**.cpp",

			depsdir .. "/glm/glm/**.hpp",
			depsdir .. "/glm/glm/**.inl",

			depsdir .. "/imgui_vesk/backends/imgui_impl_glfw.cpp",
			depsdir .. "/imgui_vesk/backends/imgui_impl_opengl3.cpp",
		}

		-- Library search paths for the linker
		libdirs { depsdir }

		-- List of libraries & projects to link against
		links {
			"glfw/bin/"       .. outputdir .. "/GLFW.lib",
			"glad/bin/"       .. outputdir .. "/Glad.lib",
			"imgui_vesk/bin/" .. outputdir .. "/ImGui.lib",
			"opengl32.lib"
		}


		postbuildcommands {
			"xcopy /y /i /q /d %{wks.location}\\bin\\%{outputdir}\\*.exe " .. builddir,
			"xcopy /y /i /q /d %{wks.location}\\*.ini "                    .. builddir,
			"xcopy /y /i /q /d %{wks.location}\\assets\\* "                .. builddir
		}


		filter "system:windows"
			systemversion "latest"
		filter "system:linux"
			-- links { }
		filter "system:macosx"
			-- links { }

		filter "configurations:Debug"
			defines "VESK_DEBUG"
			runtime "Debug"
			symbols "on"

		filter "configurations:Release"
			defines "VESK_RELEASE"
			runtime "Release"
			optimize "on"

		filter {}  -- reset filter
