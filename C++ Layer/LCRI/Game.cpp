#include "Engine.h"
#include "LevelPlayer.h"
#include "AssemblyLoader.h"

void Start()
{
	AssemblyLoader::Load();
	LevelPlayer::LoadLevel("test");
}