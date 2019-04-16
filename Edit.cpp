#include "Edit.h"

bool Edit::firstObject = true;

// Konstruktory i Destruktor ----------------------------------------------------------------------

Edit::Edit()
{
	lenght = 10;
	text = { 0 },
	minPositionX = 0;
	minPositionY = 0;
	textColor = 7;
	backgroundColor = 0 ;
	firstVisibleIndex = 0;

	cursorPosition.X = minPositionX;
	cursorPosition.Y = minPositionY;
	handleOut = GetStdHandle(STD_OUTPUT_HANDLE);
	handleIn = GetStdHandle(STD_INPUT_HANDLE);
	text.resize(0);

	if (firstObject == true)
	{
		defaultColor = loadDefaultColor();
		firstObject = false;
	}
}

Edit::Edit(const Edit &copy)
{
	lenght = copy.lenght; 
	text = copy.text;
	minPositionX = copy.minPositionX;
	minPositionY = copy.minPositionY;
	textColor = copy.textColor;
	backgroundColor = copy.backgroundColor;
	firstVisibleIndex = copy.firstVisibleIndex;

	cursorPosition.X = minPositionX;
	cursorPosition.Y = minPositionY;
	handleOut = GetStdHandle(STD_OUTPUT_HANDLE);
	handleIn = GetStdHandle(STD_INPUT_HANDLE);
}

Edit::~Edit()
{
}

// ------------------------------------------------------------------------------------------------




// Prywatne Metody -------------------------------------------------------------------------------

KEY_EVENT_RECORD Edit::keyEvent()
{
	DWORD number;
	INPUT_RECORD cin;

	while (true)
	{														//
		ReadConsoleInput(handleIn, &cin, 1, &number);		//
		if (cin.EventType && cin.Event.KeyEvent.bKeyDown)	// Petla wykunuje siê dupóki nie nie zostanie
		{													// naciœniêty klawisz z klawiatury.
			return cin.Event.KeyEvent;						//
		}													//
	}
}

void Edit::createTextBox(const std::string & text)
{
	if (text.length() < lenght)
	{
		displayText(cursorPosition.X + text.length());		// kursor zostaje ustawiony na ostatniej literze w tekœcie.
	}
	else
	{
		firstVisibleIndex = text.length() - lenght;		// przesuwa wyœwietlany text na ostatnie litery w tekœcie.
		displayText(minPositionX + lenght);				// kursor zostaje ustawiony na maksymalnej pozycji.
	}
	charCounter();
}

void Edit::charCounter()
{
	COORD currentPositon = cursorPosition;		// zapisuje ustawenie kursora.

	position(minPositionX, minPositionY + 1);
	for (int i = 0; i < 20; i++)
	{											//
		std::cout << " ";						// resetowanie ekranu.
	}											//

	position(minPositionX, minPositionY + 1);
	std::cout << "Zapisano znkow: ";

	if (text.length() < 9999)
	{
		std::cout << text.length();
	}
	else
	{
		std::cout << ">10k";
	}
	position(currentPositon.X, currentPositon.Y);	// wraca od pozyji wejœciowej.
}

WORD Edit::loadDefaultColor()
{
	_CONSOLE_SCREEN_BUFFER_INFO inf;				//
	GetConsoleScreenBufferInfo(handleOut, &inf);	// wczytujê kolor konsoli.
	return inf.wAttributes;							//
}

void Edit::position(int positionX, int positionY)
{
	cursorPosition.X = positionX;
	cursorPosition.Y = positionY;
	SetConsoleCursorPosition(handleOut, cursorPosition);
}

void Edit::displayText(int currentPositionX)
{
	position(minPositionX, minPositionY);
	for (unsigned int i = firstVisibleIndex; i < firstVisibleIndex + lenght; i++)
	{
		if (i < text.length()) std::cout << text[i];	// wyœwietla widoczne elementy textu, je¿eli text jest
		else std::cout << "-";							// mniejszy od dlugosci text boxa to puste pola zape³nia '-'.
	}
	position(currentPositionX, minPositionY);
}

// ------------------------------------------------------------------------------------------------




// Publiczne Metody -------------------------------------------------------------------------------

void Edit::display()
{
	SetConsoleTextAttribute(handleOut, backgroundColor * 16 + textColor);	// ustawia kolor t³a i textu
	setPosition(minPositionX, minPositionY);
}

void Edit::userText()
{
	KEY_EVENT_RECORD key;
	int textIndexPosition = text.length();

	createTextBox(text);

	while (true)
	{
		key = keyEvent();

		if ((key.uChar.AsciiChar >= 32) && (key.uChar.AsciiChar <= 126)) // przedzia³ znaków drukowalnych.
		{
			text.insert(textIndexPosition, 1, key.uChar.AsciiChar);  // dodaje znak na podanej pozycji w tablicy.	
			textIndexPosition++;

			if (text.length() <= lenght)
			{
				cursorPosition.X++;			// przesuwa kursor w prawo.
			}
			else
			{
				firstVisibleIndex++;		// przesuwa wyœwietlany tekst w prawo.
			}

			displayText(cursorPosition.X);
			charCounter();
		}
		else if (key.wVirtualKeyCode == VK_LEFT) // strza³ka w lewo.
		{
			if (textIndexPosition != 0)
			{
				textIndexPosition--;
				if (cursorPosition.X == minPositionX)
				{
					firstVisibleIndex--;									// przesuwa wyœwietlany tekst w lewo.
					displayText(minPositionX);								//
				}
				else
				{
					cursorPosition.X--;										// przesuwa kursor w lewo.
					SetConsoleCursorPosition(handleOut, cursorPosition);	//
				}
			}
		}
		else if (key.wVirtualKeyCode == VK_RIGHT)	// strza³ka w prawo.
		{
			if (textIndexPosition != text.length())
			{
				textIndexPosition++;
				if (cursorPosition.X == minPositionX + lenght)
				{						
					firstVisibleIndex++;									// przesuwa wyœwietlany tekst w prawo.
					displayText(minPositionX + lenght);						//
				}
				else
				{
					cursorPosition.X++;										//  przesuwa kursor w prawo.
					SetConsoleCursorPosition(handleOut, cursorPosition);	//
				}
			}
		}
		else if (key.wVirtualKeyCode == VK_BACK)	// backspace.
		{	
			if (textIndexPosition != 0)
			{
				textIndexPosition--;
				text.erase(text.begin() + textIndexPosition);	// usuwa znak z wybranej pozycji tablicy.

				if (text.length() < lenght)
				{
					cursorPosition.X--;			// przesuwa kursor w lewo.				
				}
				else
				{
					firstVisibleIndex--;		// przesuwa wyœwietlany tekst w lewo.
				}

				displayText(cursorPosition.X);
				charCounter();
			}
		}
		else if ((key.wVirtualKeyCode == VK_ESCAPE) || (key.wVirtualKeyCode == VK_RETURN)) // escape || enter.
		{
			std::cout << "\n\n\n\n";
			return;
		}
	}
}

// ------------------------------------------------------------------------------------------------




// Settery ----------------------------------------------------------------------------------------

void Edit::setPosition(int positionX, int positionY)
{
	if (positionX < 0)				
	{								
		positionX *= -1;			
	}							// zabezpieczenie przed podaniem ujemnej pozycji.
	if (positionY < 0)
	{
		positionY *= -1;
	}

	this->minPositionX = positionX;
	this->minPositionY = positionY;
	cursorPosition.X = positionX;
	cursorPosition.Y = positionY;

	SetConsoleCursorPosition(handleOut, cursorPosition);
}

void Edit::setLenght(int lenght)
{
	if (lenght < 0)
	{
		lenght *= -1;		// zabezpieczenie przed podaniem ujemnej d³ugoœæi.
	}

	this->lenght = lenght;
}

void Edit::setText(const std::string & text)
{
	this->text = text;
}

void Edit::setTextColor(COLOR textColor)
{
	this->textColor = textColor;
}

void Edit::setBackgroundColor(COLOR backgroundColor)
{
	this->backgroundColor = backgroundColor;
}

// ------------------------------------------------------------------------------------------------




// Gettery ----------------------------------------------------------------------------------------

COORD Edit::getPosition()
{
	return cursorPosition;
}

int Edit::getPositionX()
{
	return cursorPosition.X;
}
int Edit::getPositionY()
{
	return cursorPosition.Y;
}

int Edit::getLength()
{
	return lenght;
}

std::string Edit::getText()
{
	return text;
}

WORD Edit::getTextColor()
{
	return textColor;
}

WORD Edit::getBackgroundColor()
{
	return backgroundColor;
}

// ------------------------------------------------------------------------------------------------




// Operatory --------------------------------------------------------------------------------------

Edit & Edit::operator=(const Edit & obj)
{
	if (this != &obj)
	{
		lenght = obj.lenght;
		text = obj.text;
		minPositionX = obj.minPositionX;
		minPositionY = obj.minPositionY;
		textColor = obj.textColor;
		backgroundColor = obj.backgroundColor;
		cursorPosition.X = minPositionX;
		cursorPosition.Y = minPositionY;
	}
	return *this;
}

// ------------------------------------------------------------------------------------------------