#include "LevelPlayer.h"
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

void OnExit()
{
	delete[] Grid;
	delete[] BackLayer;
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
			Vector2f Position = SuperRect.getPosition();
			int c;
			in >> c;
			Grid[i * Width + j] = (c <= 2) ? c : 0;
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
		}
	}
	engine->RegisterObject(0, BackLayer);
	for (int i = 0; i < 4; i++)
	{
		engine->RegisterObject(2, &Ghost[i]);
	}
	engine->RegisterObject(1, &Pacman);
	engine->RegisterOnClose(OnExit);
}

void LevelPlayer::Main()
{

}