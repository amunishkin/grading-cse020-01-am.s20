#!/bin/bash
# lab08.sh - grades lab8 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's lab8 grading"
echo ""
#################################################

SOURCES="SimpleEngSpaTranslator.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "=========================" > $REPORT
echo "|| Grade Book for lab8 ||" >> $REPORT
echo "=========================" >> $REPORT


echo "" >> $REPORT
#
# checks files ----------------------------------
#
for FILE in $SOURCES; do
  if [ ! -e "$FILE" ]; then
    echo "$FILE absent (-30 pts)" >> $REPORT
    ((GRADE = GRADE - 30))
  fi
done
if ((GRADE == GRADE_MAX)); then
  echo "Good Job! File names are correct" >> $REPORT
fi

echo "" >> $REPORT
#
# checks that program runs ----------------------
#
# find *.py filenames : extra check
ls ./*.py > py.files 
cat py.files
if [ -s py.files ]; then        # Only if py file exists
  while read line; do
    name="$line"
    echo "${line##*/}" > base.name
    basename=""
    while read line; do
      basename="$line"
    done < base.name
    rm base.name
    
    #trap '' INT
    ###################################
    # Run1:
    cat run1.txt | python $name &> run1.messages
    # Run2:
    cat run2.txt | python $name &> run2.messages
    # Run3:
    cat run3.txt | python $name &> run3.messages
    # Run4:
    cat run4.txt | python $name &> run4.messages
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
    grep "[Ee]rror" run2.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run3.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run4.messages | grep -v "EOFError" >> err.messages
    
    # print code run
    echo "---------- python run1 -----------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run1.messages >> $REPORT
    echo "---------- python run2 -----------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run2.messages >> $REPORT
    echo "---------- python run3 -----------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run3.messages >> $REPORT
    echo "---------- python run4 -----------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run4.messages >> $REPORT
    echo "----------------------------------" >> $REPORT
    #

    # check run1 output
    grep "hello" run1.messages | grep "translated to" | grep "hola" > run1.out
    if [ ! -s run1.out ]; then
      echo "Run1's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run2 output
    grep "bye" run2.messages | grep "translated to" | grep "adios" > run2.out
    if [ ! -s run2.out ]; then
      echo "Run2's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run3 output
    grep "'hi': 'hola', 'Big': 'grande'" run3.messages > run3.out
    if [ ! -s run3.out ]; then
      echo "Run3's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run4 output
    grep "HI" run4.messages | grep "translated to" | grep "HOLA" > run4.out
    if [ ! -s run4.out ]; then
      echo "Run4's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    rm run*.out

    # error messages check
    if [ -s err.messages ]; then
      echo "Your program has errors (-30 pts)" >> $REPORT
      ((GRADE = GRADE - 30))
    fi
    rm *.messages 

  done < py.files
else                            # Otherwise no py file
  echo "There is no Python file that can be tested (-70 pts)" >> $REPORT
  ((GRADE = GRADE - 70))
fi
rm py.files



#
echo "" >> $REPORT
#
# finalizes grade -------------------------------
#
echo "##################" >> $REPORT
echo "# GRADE = $GRADE #" >> $REPORT
echo " GRADE = $GRADE "
echo "##################" >> $REPORT
echo "" >> $REPORT
#

#################################################
echo ""
echo " FINISH ... running student's lab8 grading"
echo ""

