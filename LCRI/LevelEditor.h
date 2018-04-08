#pragma once
#include "Engine.h"

namespace LevelEditor
{
	void InitializeGrid(int n);
	void Main();
	void LoadFromFile(std::string FileName);
	void UnloadToFile(std::string FileName);
}