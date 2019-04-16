#include <iostream>
#include <string>
#include "ccolor.h"
#include "edit.h"



int main()
{
	Edit e;

	e.setPosition(7, 3);
	e.setLenght(6);
	e.setText("Ala");
	e.setTextColor(Edit::White);
	e.setBackgroundColor(Edit::Blue);

	e.display();

	std::string s = e.getText();
	e.userText();
	s = e.getText();

	std::cout << red << "A" << green << "l" << blue << "a" << white << "ma";
	std::cout << SetColor(FOREGROUND_RED | FOREGROUND_GREEN) << s;
	std::cout << defcolor << std::endl;

	return 0;
}