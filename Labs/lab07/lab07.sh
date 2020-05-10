#!/bin/bash
# lab07.sh - grades lab7 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ALL ... students' lab7 grading"
echo ""
#################################################

CSV=report.csv
echo "" > report.csv # rewrite each run of program

#
# iterates through directory list
#
for i in $(ls .); do
  
  if [ -d "$i" ]; then
    echo "Inside $i ..." 
    cp lab07_student.sh $i  # copy individual script
    cp run*.txt $i          # copy four test files
    cd $i
    #
    sh lab07_student.sh
    rm lab07_student.sh     # now remove them
    rm run*.txt
    #
    cd ..
    GRADE=$(grep "GRADE" $i/grade.txt | grep -oE "[0-9]+")
    echo "$i,$GRADE" >> $CSV
  fi
done

#################################################
echo ""
echo " FINISH ALL ... students' lab7 grading"
echo ""

