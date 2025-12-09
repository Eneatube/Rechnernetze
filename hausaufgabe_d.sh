Head=$(cat ./ergebnisse.csv | head -n 1)
echo $Head
zahl=1
columnZahl=0
IFS=';' read -ra columns <<< "$Head"
for word in "${columns[@]}"; do
        if [ "$word" == "Total" ]; then
                columnZahl=$zahl
                echo $columnZahl
        fi
        ((zahl++))
done
mapfile -t TailArray < <(cat ./ergebnisse.csv | tail -n+2)
{
  echo "First Name;Family Name;Total;Grade;"
  for line in "${TailArray[@]}"; do
    IFS=';' read -ra columns <<< "$line"
    counter=1
    for word in "${columns[@]}"; do
      if [ "$counter" -eq "$columnZahl" ]; then
        summe=$word
      fi
      ((counter++))
    done
   if [ $summe -ge 95 ]; then
        note="1.0"
   elif [ $summe -ge 90 ] && [ $summe -le 94 ]; then
        note="1.3"
   elif [ $summe -ge 85 ] && [ $summe -le 89 ]; then
        note="1.7"
   elif [ $summe -ge 80 ] && [ $summe -le 84 ]; then
        note="2.0"
   elif [ $summe -ge 75 ] && [ $summe -le 79 ]; then
        note="2.3"
   elif [ $summe -ge 70 ] && [ $summe -le 74 ]; then
        note="2.7"
   elif [ $summe -ge 65 ] && [ $summe -le 69 ]; then
        note="3.0"
   elif [ $summe -ge 60 ] && [ $summe -le 64 ]; then
        note="3.3"
   elif [ $summe -ge 55 ] && [ $summe -le 59 ]; then
        note="3.7"
   elif [ $summe -ge 50 ] && [ $summe -le 54 ]; then
        note="4.0"
   elif [ $summe -lt 50 ]; then
        note="5.0"
   fi
    echo "$line""$note;"
  done
} > ergebnisse.csv
