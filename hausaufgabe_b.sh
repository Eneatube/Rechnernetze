if [ "$#" -ne 1 ]; then
    echo "Fehler: Bitte genau ein Argument angeben."
    exit 1
fi

FILE=$1

if [ ! -e "$FILE" ]; then
    echo "Fehler: Datei '$FILE' existiert nicht."
    exit 1
fi


if [ ! -f "$FILE" ]; then
    echo "Fehler: '$FILE' ist keine reguläre Datei (z.B. ein Verzeichnis)."
    exit 1
fi

if [ ! -r "$FILE" ]; then
    echo "Fehler: Keine Leserechte für '$FILE'."
    exit 1
fi
Head=$(zcat ${1} | head -n 1)
echo $Head
zahl=1
columnZahl=0
columnZahl2=0
IFS=';' read -ra columns <<< "$Head"
for word in "${columns[@]}"; do
        if [ "$word" == "Familyname" ]; then
                columnZahl=$zahl
                echo $columnZahl
        fi
        if [ "$word" == "Firstname" ]; then
                columnZahl2=$zahl
                echo $columnZahl2
        fi
        ((zahl++))
done
mapfile -t TailArray < <(zcat ${1} | tail -n+2 | sort -t';' -k${columnZahl},${columnZahl} -k${columnZahl2},${columnZahl2})
{
  echo "$Head"
  for line in "${TailArray[@]}"; do
    echo "$line"";"
  done
} > studierende.csv
