#!/bin/bash
# assignment4.sh - grades assignment4 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ALL ... students' assignment4 grading"
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
    cp assign4_student.sh $i  # copy individual script
    cp MathTest*.py $i        # copy three py test files
    cp run*.txt $i            # copy three test out files
    cd $i
    #
    sh assign4_student.sh
    rm assign4_student.sh     # now remove them
    rm MathTest*.py
    rm run*.txt
    #
    cd ..
    GRADE=$(grep "GRADE" $i/grade.txt | grep -oE "[0-9]+")
    echo "$i,$GRADE" >> $CSV
  fi
done

#################################################
echo ""
echo " FINISH ALL ... students' assignment4 grading"
echo ""

