#pragma once
typedef int(__stdcall *_InitializeStateData)(int Key, int* State);
typedef int(__stdcall *_InitializeGridData)(int* Grid, int Width, int Height);
typedef int(__stdcall *_InitializePlayerData)(int PX1, int PX2, int PY1, int PY2, int* PTX, int* PTY);
typedef int(__stdcall *_InitializeEnemyData)(int EnemyNumber, int EX1, int EX2, int EY1, int EY2, int* ETX, int* ETY);
typedef int(__stdcall *_MovePacMan)();
typedef int(__stdcall *_CheckFood)(int X, int Y);
typedef int(__stdcall *_MegaCheckDeath)();
typedef int(__stdcall *_AIMegaController)();
typedef int(__stdcall *_DebugFunction)(int);
class AssemblyLoader
{
public:
	static _DebugFunction DebugFunction;
	static _InitializeStateData InitializeStateData;
	static _InitializeGridData InitializeGridData;
	static _InitializePlayerData InitializePlayerData;
	static _InitializeEnemyData InitializeEnemyData;
	static _MovePacMan MovePacMan;
	static _CheckFood CheckFood;
	static _MegaCheckDeath CheckDeath;
	static _AIMegaController AIMegaController;
	static void Load();
};
