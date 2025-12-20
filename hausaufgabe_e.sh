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
#echo $Head
zahl=1
columnZahl=0
columnZahl2=0
IFS=';' read -ra columns <<< "$Head"
for word in "${columns[@]}"; do
        if [ "$word" == "Familyname" ]; then
                columnZahl=$zahl
 #               echo $columnZahl
        fi
        if [ "$word" == "Firstname" ]; then
                columnZahl2=$zahl
  #              echo $columnZahl2
        fi
        ((zahl++))
done
mapfile -t TailArray < <(zcat ${1} | tail -n+2 | sort -t';' -k${columnZahl},${columnZahl} -k${columnZahl2},${columnZahl2})
{
  lineCounter=1
  summeTask1=0
  summeTask2=0
  summeTask3=0
  summeTask4=0
  summeTask5=0
  summeTask6=0
  summeTask7=0
  summeTask8=0
  summeTask9=0
  summeTask10=0
  for line in "${TailArray[@]}"; do
    counter=1
    taskCounter=1
    IFS=';' read -ra columns <<< "$line"
    for world in "${columns[@]}"; do
        if [ $counter -ne $columnZahl ] && [ $counter -ne $columnZahl2 ]; then
           if [[ $taskCounter -eq 1 ]]; then
                summeTask1=$(($summeTask1+$world))
           elif [[ $taskCounter -eq 2 ]]; then
                summeTask2=$(($summeTask2+$world))
           elif [[ $taskCounter -eq 3 ]]; then
                summeTask3=$(($summeTask3+$world))
           elif [[ $taskCounter -eq 4 ]]; then
                summeTask4=$(($summeTask4+$world))
           elif [[ $taskCounter -eq 5 ]]; then
                summeTask5=$(($summeTask5+$world))
           elif [[ $taskCounter -eq 6 ]]; then
                summeTask6=$(($summeTask6+$world))
           elif [[ $taskCounter -eq 7 ]]; then
                summeTask7=$(($summeTask7+$world))
           elif [[ $taskCounter -eq 8 ]]; then
                summeTask8=$(($summeTask8+$world))
           elif [[ $taskCounter -eq 9 ]]; then
                summeTask9=$(($summeTask9+$world))
           elif [[ $taskCounter -eq 10 ]]; then
                summeTask10=$(($summeTask10+$world))
           fi
           ((taskCounter++))
#          echo $taskCounter
        fi
        ((counter++))
    done
    ((lineCounter++))
  done
    echo "Task 1: ""$(($summeTask1/$lineCounter)) points"
    echo "Task 2: ""$(($summeTask2/$lineCounter)) points"
    echo "Task 3: ""$(($summeTask3/$lineCounter)) points"
    echo "Task 4: ""$(($summeTask4/$lineCounter)) points"
    echo "Task 5: ""$(($summeTask5/$lineCounter)) points"
    echo "Task 6: ""$(($summeTask6/$lineCounter)) points"
    echo "Task 7: ""$(($summeTask7/$lineCounter)) points"
    echo "Task 8: ""$(($summeTask8/$lineCounter)) points"
    echo "Task 9: ""$(($summeTask9/$lineCounter)) points"
    echo "Task 10: ""$(($summeTask10/$lineCounter)) points"
}
