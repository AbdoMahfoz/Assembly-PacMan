#include "LevelPlayer.h"
#include "Engine.h"
#include "AssemblyLoader.h"
#include <fstream>

//.Data
int *Grid, Width, Height;
int PX1, PX2, PY1, PY2, PTX, PTY;
int EX1[4], EX2[4], EY1[4], EY2[4], ETX[4], ETY[4];
int Key, State;
float RectWidth, RectHeight;

//Walls And Food
VertexArray *BackLayer;

//Enemies and Pacman
RectangleShape Pacman, Ghost[4];

void PlayerOnExit()
{
	delete[] Grid;
	delete[] BackLayer;
	engine->UnRegisterRoutine(LevelPlayer::Main);
	engine->UnRegisterObject(0, BackLayer);
	for (int i = 0; i < 4; i++)
	{
		engine->UnRegisterObject(2, &Ghost[i]);
	}
	engine->UnRegisterObject(1, &Pacman);
}

void LevelPlayer::LoadLevel(std::string FileName)
{
	std::ifstream in;
	in.open(FileName + ".pmm");
	int Count;
	in >> Count;
	Width = Count;
	Height = (Count * VideoMode::getDesktopMode().height) / VideoMode::getDesktopMode().width;
	RectWidth = (float)VideoMode::getDesktopMode().width / Width;
	RectHeight = (float)VideoMode::getDesktopMode().height / Height;
	Grid = new int[Width * Height];
	BackLayer = new VertexArray(Quads, Width * Height * 4);
	RectangleShape SuperRect;
	int EnemyCounter = 0;
	for (int i = 0; i < Height; i++)
	{
		for (int j = 0; j < Width; j++)
		{
			SuperRect.setPosition(Vector2f(j * RectWidth, i * RectHeight));
			SuperRect.setSize(Vector2f(RectWidth, RectHeight));
			int c;
			in >> c;
			Grid[i * Width + j] = ((c <= 2) ? c : 0);
			if (c == 2)
			{
				SuperRect.move(Vector2f(RectWidth / 4.0f, RectHeight / 4.0f));
				SuperRect.setSize(Vector2f(RectWidth / 2.0f, RectHeight / 2.0f));
			}
			Vector2f Position = SuperRect.getPosition();
			for (int k = 0; k < 4; k++)
			{
				(*BackLayer)[(i * Width * 4) + (j * 4) + k].position = SuperRect.getPoint(k) + Position;
				switch (c)
				{
				case 0:
					(*BackLayer)[(i * Width * 4) + (j * 4) + k].color = Color::Black;
					break;
				case 1:
					(*BackLayer)[(i * Width * 4) + (j * 4) + k].color = Color::Blue;
					break;
				case 2:
					(*BackLayer)[(i * Width * 4) + (j * 4) + k].color = Color::Yellow;
					break;
				case 3:
					(*BackLayer)[(i * Width * 4) + (j * 4) + k].color = Color::Black;
					if (k > 0) break;
					Ghost[EnemyCounter] = SuperRect;
					Ghost[EnemyCounter].setFillColor(Color::Red);
					EX1[EnemyCounter] = j;
					EX2[EnemyCounter] = 0;
					EY1[EnemyCounter] = i;
					EY2[EnemyCounter] = 0;
					ETX[EnemyCounter] = j;
					ETY[EnemyCounter++] = i;
					break;
				case 4:
					(*BackLayer)[(i * Width * 4) + (j * 4) + k].color = Color::Black;
					if (k > 0) break;
					Pacman = SuperRect;
					Pacman.setFillColor(Color::Green);
					PX1 = j;
					PX2 = 0;
					PY1 = i;
					PY2 = 0;
					PTX = j;
					PTY = i;
					break;
				}
			}
			if (c == 2)
			{
				SuperRect.setOrigin(Vector2f(0, 0));
				SuperRect.move(Vector2f(-RectWidth / 2.0f, -RectHeight / 2.0f));
				SuperRect.setSize(Vector2f(RectWidth, RectHeight));
			}
		}
	}
	engine->RegisterObject(0, BackLayer);
	for (int i = 0; i < 4; i++)
	{
		engine->RegisterObject(2, &Ghost[i]);
	}
	engine->RegisterObject(1, &Pacman);
	engine->RegisterOnClose(PlayerOnExit);
	engine->RegisterRoutine(LevelPlayer::Main);
	AssemblyLoader::InitializeGridData(Grid, Width, Height);
}

int GetKeyNumber()
{
	int ans = 0;
	if (Keyboard::isKeyPressed(Keyboard::Up))
	{
		ans = 1;
	}
	if (Keyboard::isKeyPressed(Keyboard::Right))
	{
		if (ans != 0) return 0;
		ans = 2;
	}
	if (Keyboard::isKeyPressed(Keyboard::Down))
	{
		if (ans != 0) return 0;
		ans = 3;
	}
	if (Keyboard::isKeyPressed(Keyboard::Left))
	{
		if (ans != 0) return 0;
		ans = 4;
	}
	return ans;
}

void TranslatePosition(int& P1, int& P2, int PT)
{
	if (P1 == PT && P2 == 0)
	{
		return;
	}
	if (P1 >= PT)
	{
		P2--;
	}
	else
	{
		P2++;
	}
	if (P2 == 10)
	{
		P2 = 0;
		P1++;
	}
	if (P2 == -1)
	{
		P2 = 9;
		P1--;
	}
}

void UpdateFood()
{
	for (int i = 0; i < Height; i++)
	{
		for (int j = 0; j < Width; j++)
		{
			if (Grid[i * Width + j] == 0)
			{
				for (int k = 0; k < 4; k++)
				{
					(*BackLayer)[(i * Width * 4) + (j * 4) + k].color = Color::Black;
				}
			}
		}
	}
}

void LevelPlayer::Main()
{
	AssemblyLoader::InitializePlayerData(PX1, PX2, PY1, PY2, &PTX, &PTY);
	for (int i = 0; i < 3; i++)
	{
		AssemblyLoader::InitializeEnemyData(i + 1, EX1[i], EX2[i], EY1[i], EY2[i], &ETX[i], &ETY[i]);
	}
	AssemblyLoader::InitializeStateData(GetKeyNumber(), &State);
	AssemblyLoader::MovePacMan();
	AssemblyLoader::CheckFood(PX1, PX2, PY1, PY2);
	//AssemblyLoader::CheckDeath();
	//AssemblyLoader::AIMegaController();
	if (State)
	{
		exit(0);
	}
	TranslatePosition(PX1, PX2, PTX);
	TranslatePosition(PY1, PY2, PTY);
	Pacman.setPosition(Vector2f((PX1 * RectWidth) + ((PX2 / 10.0f) * RectWidth), (PY1 * RectHeight) + ((PY2 / 10.0f) * RectHeight)));
	UpdateFood();
}