if [[ $# -eq 0 ]] ; then
    echo 'no Argument given'
    exit 0
fi
highestScore=0
Head=$(zcat ${1} | head -n 1)
echo $Head
zahl=1
columnZahl=0
columnZahl2=0
candidates=""
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
  echo "First Name;Family Name;Total;"
  for line in "${TailArray[@]}"; do
    IFS=';' read -ra columns <<< "$line"
    counter=1
    summe=0
    for word in "${columns[@]}"; do
      if [ "$counter" -ne "$columnZahl" ] && [ "$counter" -ne "$columnZahl2" ]; then
        summe="$(($summe + $word))"
      fi
      ((counter++))
    done
    if [ "$summe" -gt "$highestScore" ]; then
      highestScore=$summe
    fi
  done
  for line in "${TailArray[@]}"; do
    IFS=';' read -ra columns <<< "$line"
    counter=1
    summe=0
    curFamilyName=""
    curFirstName=""
    for word in "${columns[@]}"; do
      if [ "$counter" -ne "$columnZahl" ] && [ "$counter" -ne "$columnZahl2" ]; then
        summe="$(($summe + $word))"
      elif [ "$counter" -eq "$columnZahl" ]; then
        curFamilyName=$word
      elif [ "$counter" -eq "$columnZahl2" ]; then
        curFirstName=$word
      fi
    
      ((counter++))
    done
    if [ "$summe" -eq "$highestScore" ]; then
      if [ -z "${candidates}" ]; then
         candidates+="$curFirstName $curFamilyName"
      else
         candidates+=", $curFirstName $curFamilyName"
      fi
    fi
  done
  echo "Highest score students with $highestScore points: $candidates"
}