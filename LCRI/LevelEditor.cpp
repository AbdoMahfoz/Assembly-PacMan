#include "LevelEditor.h"
#include <fstream>

int width, height, Count;

std::vector < std::vector < bool > > *Map;

VertexArray *Grid;

void OnExit()
{
	delete Grid, Map;
}

Vector2i MouseToGrid()
{
	Vector2i pos = Mouse::getPosition();
	return Vector2i((int)((pos.y / (long double)VideoMode::getDesktopMode().height) * height), (int)((pos.x / (long double)VideoMode::getDesktopMode().width) * width));
}

void LevelEditor::InitializeGrid(int n)
{
	engine->RegisterRoutine(Main);
	Count = n;
	width = Count;
	height = (Count * VideoMode::getDesktopMode().height) / VideoMode::getDesktopMode().width;
	float RectWidth = (float)VideoMode::getDesktopMode().width / width;
	float RectHeight = (float)VideoMode::getDesktopMode().height / height;
	Grid = new VertexArray(Quads, width * height * 4);
	Map = new std::vector < std::vector < bool > >(height, std::vector < bool >(width));
	RectangleShape SuperRect;
	SuperRect.setSize(Vector2f(RectWidth - 1, RectHeight - 1));
	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width; j++)
		{
			if (i == 0 || j == 0)
			{
				SuperRect.setPosition(Vector2f((j * RectWidth) + 1, (i * RectHeight) + 1));
				SuperRect.setSize(Vector2f(RectWidth - 2, RectHeight - 2));
			}
			else
			{
				SuperRect.setPosition(Vector2f(j * RectWidth, i * RectHeight));
			}
			Vector2f position = SuperRect.getPosition();
			(*Grid)[(i * width * 4) + (j * 4)].position = SuperRect.getPoint(0) + position;
			(*Grid)[(i * width * 4) + (j * 4) + 1].position = SuperRect.getPoint(1) + position;
			(*Grid)[(i * width * 4) + (j * 4) + 2].position = SuperRect.getPoint(2) + position;
			(*Grid)[(i * width * 4) + (j * 4) + 3].position = SuperRect.getPoint(3) + position;
			(*Grid)[(i * width * 4) + (j * 4)].color = Color::Black;
			(*Grid)[(i * width * 4) + (j * 4) + 1].color = Color::Black;
			(*Grid)[(i * width * 4) + (j * 4) + 2].color = Color::Black;
			(*Grid)[(i * width * 4) + (j * 4) + 3].color = Color::Black;
			(*Map)[i][j] = 0;
			if (i == 0 || j == 0)
			{
				SuperRect.setSize(Vector2f(RectWidth - 1, RectHeight - 1));
			}
		}
	}
	engine->RegisterOnClose(OnExit);
	engine->RegisterObject(0, Grid);
}

void UpdateGrid(int i, int j, Color c)
{
	(*Grid)[(i * width * 4) + (j * 4)].color = c;
	(*Grid)[(i * width * 4) + (j * 4) + 1].color = c;
	(*Grid)[(i * width * 4) + (j * 4) + 2].color = c;
	(*Grid)[(i * width * 4) + (j * 4) + 3].color = c;
}

void LevelEditor::LoadFromFile(std::string FileName)
{
	std::ifstream in;
	in.open(FileName + ".map");
	if (!in.is_open())
	{
		return;
	}
	int n;
	in >> n;
	if (n != Count)
	{
		engine->UnRegisterObject(0, Grid);
		engine->UnRegisterOnClose(OnExit);
		OnExit();
		InitializeGrid(n);
	}
	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width; j++)
		{
			int c;
			in >> c;
			for (int k = 0; k < 4; k++)
			{
				switch (c)
				{
				case 0:
					(*Grid)[(i * width * 4) + (j * 4) + k].color = Color::Black;
					(*Map)[i][j] = 0;
					break;
				case 1:
					(*Grid)[(i * width * 4) + (j * 4) + k].color = Color::Blue;
					(*Map)[i][j] = 1;
					break;
				}
			}
		}
	}
	in.close();
}

void LevelEditor::UnloadToFile(std::string FileName)
{
	std::ofstream out;
	out.open(FileName + ".map");
	out << Count << ' ';
	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width; j++)
		{
			out << (*Map)[i][j] << ' ';
		}
	}
	out.close();
}

void LevelEditor::Main()
{
	static Vector2i LastPos(0, 0);
	Vector2i pos = MouseToGrid();
	if (pos != LastPos)
	{
		if (!(*Map)[pos.x][pos.y])
			UpdateGrid(pos.x, pos.y, Color::Green);
		if (!(*Map)[LastPos.x][LastPos.y])
			UpdateGrid(LastPos.x, LastPos.y, Color::Black);
		LastPos = pos;
	}
	if (Mouse::isButtonPressed(Mouse::Button::Left))
	{
		(*Map)[pos.x][pos.y] = 1;
		UpdateGrid(pos.x, pos.y, Color::Blue);
	}
	if (Mouse::isButtonPressed(Mouse::Button::Right))
	{
		(*Map)[pos.x][pos.y] = 0;
		UpdateGrid(pos.x, pos.y, Color::Green);
	}
}