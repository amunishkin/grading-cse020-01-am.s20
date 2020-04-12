#!/bin/bash
# assignment2.sh - grades assignment2 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ALL ... students' assignment1 grading"
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
    cp assign2_student.sh $i  # copy individual script
    cd $i
    #
    sh assign2_student.sh
    rm assign2_student.sh     # now remove them
    #
    cd ..
    GRADE=$(grep "GRADE" $i/grade.txt | grep -oE "[0-9]+")
    echo "$i,$GRADE" >> $CVS
  fi
done

#################################################
echo ""
echo " FINISH ALL ... students' assignment1 grading"
echo ""

