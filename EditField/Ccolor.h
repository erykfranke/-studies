/*
Klasa: "SetColor"
Opis: Ustawia kolor konsoli oraz przechowuje w pliku manipulatory do zmiany koloru textu.
Autor: Eryk Franke.
Data utworzenia: 26.11.2018
*/

#ifndef CCOLOR_H
#define CCOLOR_H

#include <iostream>
#include <Windows.h>
#include <cmath>
#include "Edit.h"

class SetColor
{
private:
	WORD textColor;			// przechowuje kolor textu.
	WORD backgroundColor;	// przechowuje kolor t³a.

public:
	SetColor();
	SetColor(WORD color);
	~SetColor();

	friend std::ostream & operator<< (std::ostream & cout, const SetColor & obj);
};

// Manipulatory -------------------------------------------------------------------------

std::ostream& black(std::ostream & edit);
std::ostream& darkBlue(std::ostream & edit);
std::ostream& darkGreen(std::ostream & edit);
std::ostream& darkCyan(std::ostream & edit);
std::ostream& darkRed(std::ostream & edit);
std::ostream& darkMagenta(std::ostream & edit);
std::ostream& darkYellow(std::ostream & edit);
std::ostream& darkGray(std::ostream & edit);
std::ostream& gray(std::ostream & edit);
std::ostream& blue(std::ostream & edit);
std::ostream& green(std::ostream & edit);
std::ostream& cyan(std::ostream & edit);
std::ostream& red(std::ostream & edit);
std::ostream& magenta(std::ostream & edit);
std::ostream& yellow(std::ostream & edit);
std::ostream& white(std::ostream & edit);

std::ostream & defcolor(std::ostream & edit);

#endif
