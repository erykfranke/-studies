/*
Klasa "Edit"
Opis: klasa daje mo�lwo�� stworzenia pola edycyjnego, wraz z mo�liwo�ci� zmiany jej
	  pozycji, d�ugo�ci czy koloru jak i r�wnie� z wpradzeniem pocz�tkowego tekstu.
Autor: Eryk Franke.
Data utworzenia: 26.11.2018
*/

#ifndef EDIT_H
#define EDIT_H

#include <Windows.h>
#include <iostream>
#include <string>

class Edit
{
private:

 // Pola -----------------------------------------------------------------------------

	std::string text;		// przechowuje ustawione lub wpisane ci�gi znak�w.
	int lenght;				// d�ugo�c text boxa.
	WORD textColor;			// przechowuje kolor tekstu.
	WORD backgroundColor;	// przechowuje kolor t�a.
	COORD cursorPosition;	// przechowuje pozycj� kursora.

	int minPositionX;		// przechowuje ustawion� X-ow� pozycje kursora.
	int minPositionY;		// przechowuje ustawion� Y-ow� pozycje kursora.
	int firstVisibleIndex;	// pozycja pierwszego widocznego indeksu w text boxie.
	
	HANDLE handleOut;		// przechowuje uchwyt do outputu.
	HANDLE handleIn;		// przechowuje uchwyt do inputu.
	
	static bool firstObject; // zmienna przechowuje informacje o utworzeniu pierwszego obiektu.

 // -------------------------------------------------------------------------------------

	
 // Prywatne Metody ---------------------------------------------------------------------

	KEY_EVENT_RECORD keyEvent();					// wczytuje znak z klawiatury.
	void position(int positionX, int positionY);	// ustawia pozycje kursora na podanych parametrach.
	void createTextBox(const std::string & text);	// tworzy text boxa z wpisanym tekstem kt�ry jest parametrem.
	void charCounter();								// zlicza ilo�� wpisanych znakow i wyswietla je na ekranie.
	void displayText(int currentPosition); 			// wy�wietla text, jej paramert s�u�y do powrotu na pozycje wej�ciow�.
	WORD loadDefaultColor(); 						// wczytuje domy�lny kolor konsoli.

 // -------------------------------------------------------------------------------------

public:

	enum COLOR
	{
		Black, DarkBLue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, DarkGray,
		Gray, Blue, Green, Cyan, Red, Magenta, Yellow, White
	};

 // Konstrukory i destruktor ---------------------------------------------------------

	Edit();
	Edit(const Edit &copy);
	~Edit();

 // -------------------------------------------------------------------------------------


 // Publiczne Metody --------------------------------------------------------------------

	void display();		// wprowadza w �ycie ustawione zmiany.
	void userText();	// tworzy edytowalne okienko tekstowe.
						
 // -------------------------------------------------------------------------------------

	
 // Seterry -----------------------------------------------------------------------------

	void setPosition(int positionX, int positionY);
	void setLenght(int lenght);
	void setText(const std::string & text);
	void setTextColor(COLOR textColor);
	void setBackgroundColor(COLOR backgroundColor);

 // -------------------------------------------------------------------------------------


 // Gettery -----------------------------------------------------------------------------

	COORD getPosition();
	int getPositionX();
	int getPositionY();
	int getLength();
	std::string getText();
	WORD getTextColor();
	WORD getBackgroundColor();

 // -------------------------------------------------------------------------------------


 // Operatory ---------------------------------------------------------------------------

	Edit & operator=(const Edit & obj);

 // -------------------------------------------------------------------------------------
};

_declspec(selectany) WORD defaultColor; // Globalna zmienna kt�ra przechowuje domy�lny kolor konsoli

#endif