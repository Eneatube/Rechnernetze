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
    echo "$line"
  done
} > studierende.csv