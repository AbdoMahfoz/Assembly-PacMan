#include "Engine.h"
#include "LevelEditor.h"
#include "AssemblyLoader.h"

void Finialize()
{
	LevelEditor::UnloadToFile("test");
}

void Start()
{
	engine->RegisterOnClose(Finialize);
	AssemblyLoader::Load();
	engine->Log(std::to_string(AssemblyLoader::DebugFunction(5)));
	LevelEditor::InitializeGrid(30);
	LevelEditor::LoadFromFile("test");
}