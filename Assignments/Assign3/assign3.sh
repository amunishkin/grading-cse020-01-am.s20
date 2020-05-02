#!/bin/bash
# assignment3.sh - grades assignment3 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ALL ... students' assignment3 grading"
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
    cp assign3_student.sh $i  # copy individual script
    cp run*.txt $i            # copy four test files
    cd $i
    #
    sh assign3_student.sh
    rm assign3_student.sh     # now remove them
    rm run*.txt
    #
    cd ..
    GRADE=$(grep "GRADE" $i/grade.txt | grep -oE "[0-9]+")
    echo "$i,$GRADE" >> $CSV
  fi
done

#################################################
echo ""
echo " FINISH ALL ... students' assignment3 grading"
echo ""

