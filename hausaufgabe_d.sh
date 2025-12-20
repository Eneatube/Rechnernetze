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
mapfile -t TailArray < <(zcat ${1} | tail -n+2)
{
  echo "Firstname;Familyname;Total;"
  for line in "${TailArray[@]}"; do
    IFS=';' read -ra columns <<< "$line"
    counter=1
    summe=0
    for word in "${columns[@]}"; do
      if [ "$counter" -ne "$columnZahl" ] && [ "$counter" -ne "$columnZahl2" ]; then
        summe="$(($summe + $word))"
      fi
      if [ "$counter" -eq "$columnZahl" ]; then
        curFamilyName=$word
      fi
      if [ "$counter" -eq "$columnZahl2" ]; then
        curFirstName=$word
      fi
      ((counter++))
    done
    echo "$curFirstName"";""$curFamilyName"";""$summe"";"
  done
} > ergebnisse.csv
Head=$(cat ./ergebnisse.csv | head -n 1)
  #echo $Head
  zahl=1
  columnZahl=0
  IFS=';' read -ra columns <<< "$Head"
  for word in "${columns[@]}"; do
        if [ "$word" == "Total" ]; then
                columnZahl=$zahl
                #echo "$zahl" "Set"
                #echo "new Column Zahl $columnZahl"
        fi
        ((zahl++))
  done

mapfile -t TailArray2 < <(cat ./ergebnisse.csv | tail -n+2)
{
  summe2=0
  echo "Firstname;Familyname;Total;Grade"
  for line in "${TailArray2[@]}"; do
    IFS=';' read -ra columns2 <<< "$line"
    counter=1
    for word in "${columns2[@]}"; do
      if [[ $counter -eq $columnZahl ]]; then
         summe2=$word
        # echo "Sum2Set"
      fi
     # echo "counter:""$counter"
      ((counter++))
    done
#    echo $summe2
    if [[ $summe2 -ge 95 ]]; then
           note="1,0"
    elif [[ $summe2 -ge 90 ]] && [[ $summe2 -le 94 ]]; then
           note="1,3"
    elif [[ $summe2 -ge 85 ]] && [[ $summe2 -le 89 ]]; then
           note="1,7"
    elif [[ $summe2 -ge 80 ]] && [[ $summe2 -le 84 ]]; then
           note="2,0"
    elif [[ $summe2 -ge 75 ]] && [[ $summe2 -le 79 ]]; then
           note="2,3"
    elif [[ $summe2 -ge 70 ]] && [[ $summe2 -le 74 ]]; then
           note="2,7"
    elif [[ $summe2 -ge 65 ]] && [[ $summe2 -le 69 ]]; then
           note="3,0"
    elif [[ $summe2 -ge 60 ]] && [[ $summe2 -le 64 ]]; then
           note="3,3"
    elif [[ $summe2 -ge 55 ]] && [[ $summe2 -le 59 ]]; then
           note="3,7"
    elif [[ $summe2 -ge 50 ]] && [[ $summe2 -le 54 ]]; then
           note="4,0"
    elif [[ $summe2 -lt 50 ]]; then
           note="5,0"
    fi
    echo "$line""$note"
  done
} > ergebnisse.csv