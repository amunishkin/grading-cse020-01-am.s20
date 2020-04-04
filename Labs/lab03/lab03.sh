#!/bin/bash
# lab03.sh - grades lab3 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ALL ... students' lab3 grading"
echo ""
#################################################

CVS=report.csv
echo "" > report.csv # rewrite each run of program

#
# iterates through directory list
#
for i in $(ls .); do
  
  if [ -d "$i" ]; then
    echo "Inside $i ..." 
    cp lab03_student.sh $i  # copy individual script
    cd $i
    #
    sh lab03_student.sh
    rm lab03_student.sh     # now remove script
    #
    cd ..
    GRADE=$(grep "GRADE" $i/grade.txt | grep -oE "[0-9]+")
    echo "$i,$GRADE" >> $CVS
  fi
done

#################################################
echo ""
echo " FINISH ALL ... students' lab3 grading"
echo ""

