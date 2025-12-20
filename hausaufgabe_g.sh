#!/bin/bash
#
# Bash Skript zur Teilaufgabe g der Hausaufgabe:
# 
#
#
# Prüfen ob überhaupt Argumente übergeben werden?

#--------------------[zu d]--------------------#
DIR0="${1}"
DIR1="${2}"

if [[ "${#}" -ne 2 ]]
then
 echo "Eingabedatei kann nicht gelesen werden"
 exit 1
fi

# Prüft, ob das Argument 1 eine Datei ist?
if [[ ! -f "${DIR0}" ]]
then
 echo "Eingabedatei kann nicht gelesen werden"
 exit 1
fi

# Prüft, ob die Datei0 existiert (-e) UND lesbar (-r) ist?
if [[ ! -e "${DIR0}" || ! -r "${DIR0}" ]]
then
 echo "Eingabedatei kann nicht gelesen werden"
 exit 1
fi

# Prüft, ob DIR1 eine gültige positive Zahl ist?
if [[ ! "$DIR1" =~ ^[1-9][0-9]*$ ]]
then
 echo "Eingabezahl kann nicht gelesen werden"
 exit 1
fi

# Wir zählen alle Zeilen in der Datei direkt
ALLLINES=$(zcat "${DIR0}" | wc -l)

# Wir ziehen 1 ab (die Kopfzeile zählt nicht mit)
MAXDATALINES=$((ALLLINES - 1))

# Wenn die gewünschte Nummer größer ist als die echten Datenzeilen -> Fehler
if [[ "$DIR1" -gt "$MAXDATALINES" ]]
then
 echo "Zeilennummer existiert nicht"
 exit 1
fi

#--------------------[zu d]--------------------#
# wir schneiden die Datei auf in Head: die erste Zeile, und Body: der Rest.
Head=$(zcat "${DIR0}" | head -n 1)
Body=$(zcat "${DIR0}" | tail -n +2)

# Nehme die 1. Zeile aus der Eingabedatei
LINE=$(echo "$Body" | head -n "$DIR1" | tail -n 1)
NAMES=$(echo "${LINE}" | cut -d ";" -f 1-2 | tr ";" " ")

MAXLINES=$(echo "$Body" | wc -l)

# Überschrift ausgeben
echo "Result for $NAMES"
echo "+---------+----------+"

# Grafische Ausgabe der Tasks:
for ((i=3; i<13; i++))
do
 POINTS=$(echo "${LINE}" | cut -d ";" -f "${i}")
 TOTAL=$(("${TOTAL}" + "${POINTS}"))
 # "Task i" ausgeben (mit -n, damit wir in der Zeile bleiben)
 evili=$((i - 2))
 if [[ "${evili}"  -lt 10 ]]; then
  # Task 1-9: Zwei Leerzeichen Abstand innen
  echo -n "| Task ${evili}  |"
 else
  # Task 10: Ein Leerzeichen Abstand innen
  echo -n "| Task ${evili} |"
 fi
 # Innere Schleife 1: So viele Rauten drucken wie Punkte da sind
 for((p=0; p<"${POINTS}"; p++))
 do
  echo -n "#"
 done
 # Innere Schleife 2: Leerzeichen die noch fehlen
 for((l=0; l<(10 - "${POINTS}"); l++))
 do
  echo -n " "
 done
 #Zeilenumbruch und Border
 echo  "|"
done

# Fußzeile und Total ausgabe
echo "+---------+----------+"
SPACES_NEEDED=$((9 - ${#TOTAL}))
echo -n "| Total   |"
for ((s=0; s<SPACES_NEEDED; s++)); do
    echo -n " "
done

echo "$TOTAL |"
echo "+---------+----------+"