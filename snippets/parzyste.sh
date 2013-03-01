
parzystosc=$(expr $liczba % 2)    
if [ $parzystosc = 1 ]; then
    echo $liczba jest nieparzysta
fi
