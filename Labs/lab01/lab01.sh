#!/bin/bash
# lab01.sh - grades lab1 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

DIR=/afs/cats.ucsc.edu/class/cmps011-pt.s15/spa1
#DIR=~/private/_grading/tests

CVS=report.csv
echo "" > report.csv # rewrite each run of program

#
# iterates through directory list
#
for i in $(ls ${DIR}); do
  
  if [ -d "${DIR}/${i}" ]; then
    GRADE  = 80
    REPORT = grade
    
    sh lab01_student.sh
    #
    mv $REPORT ${DIR}/${i}
  fi
done

echo ""
echo "DONE"
echo ""

