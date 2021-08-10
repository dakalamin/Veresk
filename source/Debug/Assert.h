#pragma once

// Only there could VESK_ENABLE_ASSERTS be defenied 
// So we make sure it has be taken into account
// before implementing VESK_ASSERT functionality
#include "Core/Base.h"


#ifdef VESK_ENABLE_ASSERTS
	#include <cassert>
	#include <filesystem>
	#include <iostream>

	#define VESK_INTIMPL_ASSERT(expr, message, file, line) { \
	std::cerr << "Assert '" << VESK_STRINGIFY_MACRO(expr) << "' failed at\n" << file << ": " << line << '\n'; \
	std::cerr << '\n' << message << '\n'; \
	VESK_DEBUGBREAK(); }

	#define VESK_ASSERT(expr, message) \
	if (!(expr)) VESK_INTIMPL_ASSERT(expr, message, std::filesystem::path(__FILE__).filename().string(), __LINE__);

#else
	#define VESK_ASSERT(...)
#endif
