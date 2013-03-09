#!/bin/bash

# $1 - ścieżka do pliku z listą utworów do przetworzenia
# $2 - nazwa pliku pod jaką zapisać gotowy pdf

# plik listaUtworow.txt mógł istnieć wcześniej
mv --force listaUtworow.txt listaUtworow.txt~ 2> /dev/null

nutyEpifanii=~/Dropbox/Epifania/nuty

while read string; do
    # na wypadek gdyby plik z listą miał Windowsowe końce linii (CRLF)
    # to trzeba zacząć od wyrzucenia CR ze stringów
    nazwa=$(echo "$string" | tr -d '\r')

    # w pliku z listą mogą być puste linijki - nie wyszukuj ich
    # (szukanie pustych linijek zwraca wszystko).
    # pomiń również komentarze, zaczynające się od # lub %.
    if [[ "$nazwa" != "" && "$nazwa" != \#* && "$nazwa" != %* ]]; then
        sciezkaDoPliku=$(find $nutyEpifanii | grep "$nazwa" | grep .pdf)

        if [ "$sciezkaDoPliku" = "" ]; then
            echo Nie znalazłam pliku o nazwie \"$nazwa\".
        elif  [[ $sciezkaDoPliku == *$'\n'* ]]; then
            echo -en "Znalazłam więcej niż jeden plik pasujący do \n\"$nazwa\":\n"
            echo -en "$sciezkaDoPliku\n"
        else
            echo "$sciezkaDoPliku" >> listaUtworow.txt
        fi
    fi
done < "$1"

sed '/^$/d' listaUtworow.txt > temp
mv --force temp listaUtworow.txt

$scripts/pdf-merge-on-odd-page.py listaUtworow.txt > $2

rm listaUtworow.txt
mv --force temp listaUtworow.txt~ listaUtworow.txt 2> /dev/null

# otwórz gotowy pdf za pomocą domyślnej aplikacji
#gnome-open $2 &
