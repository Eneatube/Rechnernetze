if [[ $# -eq 0 ]] ; then
    echo 'no Argument given'
    exit 0
fi
if [ ${2} -gt (wc -l ${1}) ] && [ ${2} -lt 0 ]; then
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
    summe=0
    IFS=';' read -ra columns <<< "${TailArray[${2}]}"
    counter=1
    taskCounter=1
    
    curTableLine=""
    for wordl in "${columns[@]}"; do
        if [ $counter -ne $columnZahl ] && [ $counter -ne $columnZahl2 ]; then
            echo "Task "$taskCounter" --> "$wordl
            summe="$(($summe + $wordl))"
            hashtags=""
            for((i=0; i<$wordl;i++)); do
                if [ $wordl -gt $i ]; then
                    hashtags+="#"
                fi
            done
            if [ taskCounter -lt 10 ]; then
                myArray[$taskCounter]="| Task "$taskCounter"  |"$hashtags"|"
            else
                myArray[$taskCounter]="| Task "$taskCounter" |"$hashtags"|"
            fi
           
            ((taskCounter++))
        elif [ "$counter" -eq "$columnZahl" ]; then
            curFamilyName=$word
        elif [ "$counter" -eq "$columnZahl2" ]; then
            curFirstName=$word
        fi
        ((counter++))
    done
    echo "Ergebnis für $curFirstName $curLastName: "
    echo "+-----------+------------+"
    for(( i=0; i<${#myArray[@]}; i++)); do
        printf "| %-9s | %-10s |\n" "Task $((i+1))" "${myArray[i-1]}"
    done
    echo "+-----------+------------+"
    printf "| %-9s | %10s |\n" "Total" "$summe"
    echo "+-----------+------------+"
}

