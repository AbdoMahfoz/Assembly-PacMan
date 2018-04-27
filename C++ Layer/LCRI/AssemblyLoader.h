#pragma once
typedef int(__stdcall *_DebugFunction)(int);
class AssemblyLoader
{
public:
	static _DebugFunction DebugFunction;
	static void Load();
};
