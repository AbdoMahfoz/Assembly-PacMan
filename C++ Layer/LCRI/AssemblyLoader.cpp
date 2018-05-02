#include "AssemblyLoader.h"
#include <Windows.h>
#include <assert.h>

_InitializeStateData AssemblyLoader::InitializeStateData = nullptr;
_InitializeGridData AssemblyLoader::InitializeGridData = nullptr;
_InitializePlayerData AssemblyLoader::InitializePlayerData = nullptr;
_InitializeEnemyData AssemblyLoader::InitializeEnemyData = nullptr;
_MovePacMan AssemblyLoader::MovePacMan = nullptr;
_CheckFood AssemblyLoader::CheckFood = nullptr;
_MegaCheckDeath AssemblyLoader::CheckDeath = nullptr;
_AIMegaController AssemblyLoader::AIMegaController = nullptr;
_DebugFunction AssemblyLoader::DebugFunction = nullptr;

void AssemblyLoader::Load()
{
	HINSTANCE instance = LoadLibrary(L"Project.dll");
	assert(instance);
	InitializeStateData = (_InitializeStateData)GetProcAddress(instance, "InitializeStateData");
	assert(InitializeStateData != nullptr);
	InitializeGridData = (_InitializeGridData)GetProcAddress(instance, "InitializeGridData");
	assert(InitializeGridData != nullptr);
	InitializePlayerData = (_InitializePlayerData)GetProcAddress(instance, "InitializePlayerData");
	assert(InitializePlayerData != nullptr);
	InitializeEnemyData = (_InitializeEnemyData)GetProcAddress(instance, "InitializeEnemyData");
	assert(InitializeEnemyData != nullptr);
	MovePacMan = (_MovePacMan)GetProcAddress(instance, "MovePacMan");
	assert(MovePacMan != nullptr);
	CheckFood = (_CheckFood)GetProcAddress(instance, "CheckFood");
	assert(CheckFood != nullptr);
	CheckDeath = (_MegaCheckDeath)GetProcAddress(instance, "MegaCheckDeath");
	assert(CheckDeath != nullptr);
	AIMegaController = (_AIMegaController)GetProcAddress(instance, "AIMegaController");
	assert(AIMegaController != nullptr);
	DebugFunction = (_DebugFunction)GetProcAddress(instance, "DebugFunction");
	assert(DebugFunction(5) == 10);
}