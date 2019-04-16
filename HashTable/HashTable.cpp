/*
Program: HashTable
Autor: Eryk Franke.
Data utworzenia: 20.02.2019
*/

#include <iostream>
#include <string>
#include <vector>

class HashTable
{
	std::vector<std::pair<long, std::string>> hashTable;
	std::vector<bool> pomocnicza; // tablica zapamietuje czy element byl dodany przed czy po okrezeniu hasha
	const int PUSTY = -1;
public:
	HashTable();
	~HashTable();

	void add(long klucz, const std::string &tekst);
	void erase(long klucz);
	void size(const long rozmiar);
	void print();
	void clear();

private:
	void wyczyscElement(const unsigned long index);
	unsigned long IndeksKonczacyIteracje(long klucz) const;

};

HashTable::HashTable() : hashTable(0), pomocnicza(0)
{
}

HashTable::~HashTable()
{
}

void HashTable::add(long klucz, const std::string &tekst)
{
	bool przeiterowalemTablice = false;
	long indeks = klucz % hashTable.size();
	int zakonczIteracje = IndeksKonczacyIteracje(klucz);

	while (indeks != zakonczIteracje)
	{
		if (hashTable[indeks].first == PUSTY)
		{
			if (przeiterowalemTablice == false)
				pomocnicza[indeks] = true;
			else
				pomocnicza[indeks] = false;

			hashTable[indeks].first = klucz;
			hashTable[indeks].second = tekst;
			break;
		}
		else if (hashTable[indeks].first == klucz)
		{
			hashTable[indeks].second = tekst;
			break;
		}

		if (indeks == hashTable.size() - 1) {
			if (indeks + 1 == zakonczIteracje) break;
			indeks = 0;
			przeiterowalemTablice = true;
			continue;
		}
		indeks++;
	}
}

void HashTable::erase(long klucz)
{
	long index = klucz % hashTable.size();
	int zakonczIteracje = IndeksKonczacyIteracje(klucz);
	bool znalazlemKlucz = false;

	while (index != zakonczIteracje && hashTable[index].first != PUSTY)
	{


		if (hashTable[index].first == klucz && znalazlemKlucz == false)
		{
			pomocnicza[index] = true;
			wyczyscElement(index);
			klucz = index;
			znalazlemKlucz = true;
		}

		else if (pomocnicza[index] == false)
		{
			hashTable[klucz] = hashTable[index];
			if (klucz < index)
				pomocnicza[klucz] = pomocnicza[index];
			wyczyscElement(index);
			klucz = index;
		}

		else if (hashTable[index].first % long(hashTable.size()) <= klucz && znalazlemKlucz == true && pomocnicza[index] == true)
		{
			hashTable[klucz] = hashTable[index];
			if (klucz < index)
				pomocnicza[klucz] = pomocnicza[index];
			wyczyscElement(index);
			klucz = index;
		}
		else if (hashTable[index].first % long(hashTable.size()) >= klucz && znalazlemKlucz == true && pomocnicza[index] == false)
		{
			hashTable[klucz] = hashTable[index];
			if (klucz < index)
				pomocnicza[klucz] = pomocnicza[index];
			wyczyscElement(index);
			klucz = index;
		}


		if (index == hashTable.size() - 1) {
			if (index + 1 == zakonczIteracje) break;
			index = 0;
			continue;
		}
		index++;
	}
}

void HashTable::size(const long rozmiar)
{
	hashTable.resize(rozmiar);
	for (int i = 0; i < rozmiar; i++)
	{
		hashTable[i].first = PUSTY;
	}
	pomocnicza.resize(rozmiar);
	for (int i = 0; i < rozmiar; i++)
	{
		pomocnicza[i] = true;
	}
}

void HashTable::print()
{
	for (unsigned int j = 0; j < hashTable.size(); j++)
	{
		if (hashTable[j].first == PUSTY) continue;
		std::cout << j << " " << hashTable[j].first << " " << hashTable[j].second << std::endl;
	}
	std::cout << std::endl;
}

void HashTable::clear()
{
	hashTable.clear();
	pomocnicza.clear();
}

void HashTable::wyczyscElement(const unsigned long indeks)
{
	pomocnicza[indeks] = true;
	hashTable[indeks].first = PUSTY;
	hashTable[indeks].second = "";
}

unsigned long HashTable::IndeksKonczacyIteracje(long klucz) const
{
	long zakonczIteracje = klucz % hashTable.size() - 1;
	if (zakonczIteracje == -1)
	{
		return hashTable.size();
	}
	else
	{
		return zakonczIteracje;
	}
}



int main()
{
	std::string bufor;

	int liczbaTestowanychPrzypadkow;
	getline(std::cin, bufor);
	liczbaTestowanychPrzypadkow = stoi(bufor);

	HashTable hash;

	for (int i = 0; i < liczbaTestowanychPrzypadkow; i++)
	{
		do
		{
			getline(std::cin, bufor);

			std::string komenda;
			std::string sKlucz;
			std::string tekst;

			int liczbaSpacji = 0;
			for (unsigned int j = 0; j < bufor.length(); j++)
			{

				if (bufor[j] == ' ')
				{
					liczbaSpacji++;
					continue;
				}

				switch (liczbaSpacji)
				{
				case 0:
					komenda.push_back(bufor[j]);
					break;

				case 1:
					sKlucz.push_back(bufor[j]);
					break;

				case 2:
					tekst.push_back(bufor[j]);
					break;
				}
			}

			if (komenda == "size")
			{
				hash.size(stoi(sKlucz));
			}

			if (komenda == "add")
			{
				hash.add(stoi(sKlucz), tekst);
			}

			if (komenda == "delete")
			{
				hash.erase(stoi(sKlucz));
			}

			if (komenda == "print")
			{
				hash.print();
			}

		} while (bufor != "stop");
		hash.clear();
	}
	return 0;
}
