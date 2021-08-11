#pragma once

#include <memory>
#include <iostream>

#include "Core/PlatformDetector.h"


#ifdef VESK_DEBUG // (in premake5.lua)
	// -- (in Core/PlatformDetector.h) --
	#if defined(VESK_PLATFORM_WINDOWS)           // Windows x64
		#define VESK_DEBUGBREAK() __debugbreak()
	#elif defined(VESK_PLATFORM_LINUX)           // Linux
		#include <signal.h>
		#define VESK_DEBUGBREAK() raise(SIGTRAP)
	#else
		#error "Platform doesn't support debugbreak yet!"
	#endif

	#define VESK_ENABLE_ASSERTS
#elif VESK_RELEASE // (in premake5.lua)
	#define VESK_DEBUGBREAK()
#else
	#error "Unknown configuration, expected VESK_DEBUG/VESK_RELEASE!"
#endif

#define VESK_EXPAND_MACRO(x) x
#define VESK_STRINGIFY_MACRO(x) #x

#include "Debug/Assert.h"


template<typename T>
using Scope = std::unique_ptr<T>;

template<typename T, typename ... Args>
constexpr Scope<T> CreateScope(Args&& ... args)
{
	return std::make_unique<T>(std::forward<Args>(args)...);
}


template<typename T>
using Ref = std::shared_ptr<T>;

template<typename T, typename ... Args>
constexpr Ref<T> CreateRef(Args&& ... args)
{
	return std::make_shared<T>(std::forward<Args>(args)...);
}
