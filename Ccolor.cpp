#include "Ccolor.h"

SetColor::SetColor()
{

}

SetColor::SetColor(WORD color)
{
	if (color < 16)										//
	{													// Je¿eli podany color zmienia tylko kolor textu
		backgroundColor = floor(defaultColor / 16);		// to kolor t³a zostaje domyœlny.
		textColor = color;								//
	}
	else												//
	{													// W przeciwnym wypadku kolor robijany jest na
		backgroundColor = floor(color / 16);			// kolor t³a i textu.
		textColor = color % 16;							//
	}

	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),backgroundColor * 16 + textColor);
}

SetColor::~SetColor()
{

}

std::ostream & operator<<(std::ostream & cout, const SetColor & obj)
{
	return cout;
}

// Manipulatory -------------------------------------------------------------------------------------------------------

std::ostream& black(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 0;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkBlue(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 1;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkGreen(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 2;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkCyan(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 3;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkRed(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 4;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkMagenta(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 5;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkYellow(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 6;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& darkGray(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 7;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream& gray(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 8;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);;
	return edit;
}

std::ostream & blue(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 9;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream & green(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 10;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream & cyan(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 11;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream & red(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 12;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream & magenta(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 13;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream & yellow(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 14;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream & white(std::ostream & edit)
{
	WORD backgroundColor = floor(defaultColor / 16);
	WORD textColor = 15;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), backgroundColor * 16 + textColor);
	return edit;
}

std::ostream  & defcolor(std::ostream & edit)
{
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), defaultColor);
	return edit;
}

// --------------------------------------------------------------------------------------------------------------------