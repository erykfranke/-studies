/*
Klasa "Edit"
Opis: klasa daje mo¿lwoœæ stworzenia pola edycyjnego, wraz z mo¿liwoœci¹ zmiany jej
	  pozycji, d³ugoœci czy koloru jak i równie¿ z wpradzeniem pocz¹tkowego tekstu.
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

	std::string text;		// przechowuje ustawione lub wpisane ci¹gi znaków.
	int lenght;				// d³ugoœc text boxa.
	WORD textColor;			// przechowuje kolor tekstu.
	WORD backgroundColor;	// przechowuje kolor t³a.
	COORD cursorPosition;	// przechowuje pozycjê kursora.

	int minPositionX;		// przechowuje ustawion¹ X-ow¹ pozycje kursora.
	int minPositionY;		// przechowuje ustawion¹ Y-ow¹ pozycje kursora.
	int firstVisibleIndex;	// pozycja pierwszego widocznego indeksu w text boxie.
	
	HANDLE handleOut;		// przechowuje uchwyt do outputu.
	HANDLE handleIn;		// przechowuje uchwyt do inputu.
	
	static bool firstObject; // zmienna przechowuje informacje o utworzeniu pierwszego obiektu.

 // -------------------------------------------------------------------------------------

	
 // Prywatne Metody ---------------------------------------------------------------------

	KEY_EVENT_RECORD keyEvent();					// wczytuje znak z klawiatury.
	void position(int positionX, int positionY);	// ustawia pozycje kursora na podanych parametrach.
	void createTextBox(const std::string & text);	// tworzy text boxa z wpisanym tekstem który jest parametrem.
	void charCounter();								// zlicza iloœæ wpisanych znakow i wyswietla je na ekranie.
	void displayText(int currentPosition); 			// wyœwietla text, jej paramert s³u¿y do powrotu na pozycje wejœciow¹.
	WORD loadDefaultColor(); 						// wczytuje domyœlny kolor konsoli.

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

	void display();		// wprowadza w ¿ycie ustawione zmiany.
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

_declspec(selectany) WORD defaultColor; // Globalna zmienna która przechowuje domyœlny kolor konsoli

#endif