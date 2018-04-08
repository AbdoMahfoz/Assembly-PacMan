#include "Engine.h"
#include "LevelEditor.h"

void Finialize()
{
	LevelEditor::UnloadToFile("test");
}

void Start()
{
	engine->RegisterOnClose(Finialize);
	LevelEditor::InitializeGrid(30);
	LevelEditor::LoadFromFile("test");
}