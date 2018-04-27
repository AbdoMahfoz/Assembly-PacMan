#include "AssemblyLoader.h"
#include <Windows.h>
#include <assert.h>

_DebugFunction AssemblyLoader::DebugFunction = nullptr;

void AssemblyLoader::Load()
{
	HINSTANCE instance = LoadLibraryW(L"Project.dll");
	assert(instance);
	DebugFunction = (_DebugFunction)GetProcAddress(instance, "DebugFunction");
}