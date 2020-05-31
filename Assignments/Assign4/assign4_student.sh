#!/bin/bash
# assignment4.sh - grades assignment4 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's assignment4 grading"
echo ""
#################################################

SOURCES="MathLib.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "============================" > $REPORT
echo "|| Grade Book for assign4 ||" >> $REPORT
echo "============================" >> $REPORT


echo "" >> $REPORT
#
# checks files ----------------------------------
#
for FILE in $SOURCES; do
  if [ ! -e "$FILE" ]; then
    echo "$FILE absent (-20 pts)" >> $REPORT
    ((GRADE = GRADE - 20))
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
ls ./*.py | grep -v "MathTest" > py.files 
cat py.files
if [ -s py.files ]; then        # Only if py file exists
     
    #trap '' INT
    ###################################
    # Run1:  
    python MathTest1.py &> run1.messages
    #----------------------------------
    # Run2: 
    python MathTest2.py &> run2.messages
    #----------------------------------
    # Run3: 
    python MathTest3.py &> run3.messages
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
    grep "[Ee]rror" run2.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run3.messages | grep -v "EOFError" >> err.messages
      
    echo "" >> $REPORT
    # print code run
    echo "---------- python run1 -----------" >> $REPORT
    echo "python MathTest1.py" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run1.messages >> $REPORT
    echo "---------- python run2 -----------" >> $REPORT
    echo "python MathTest2.py" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run2.messages >> $REPORT
    echo "---------- python run3 -----------" >> $REPORT
    echo "python MathTest3.py" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run3.messages >> $REPORT
    echo "----------------------------------" >> $REPORT
    #

    # check run1 output: 
    diff -iEZb run1_out.txt run1.messages > run1.out
    if [ -s run1.out ]; then
      echo "Run1 is incorrect (-15 pts)" >> $REPORT
      cat run1.out >> $REPORT
      ((GRADE = GRADE - 15))
    fi
    # check run2 output: 
    diff -iEZb run2_out.txt run2.messages > run2.out
    if [ -s run2.out ]; then
      echo "Run2 is incorrect (-15 pts)" >> $REPORT
      cat run2.out >> $REPORT
      ((GRADE = GRADE - 15))
    fi
    # check run3 output: 
    diff -iEZb run3_out.txt run3.messages > run3.out
    if [ -s run3.out ]; then
      echo "Run3 is incorrect (-20 pts)" >> $REPORT
      cat run3.out >> $REPORT
      ((GRADE = GRADE - 20))
    fi
    rm run*.out

    # error messages check
    if [ -s err.messages ]; then
      echo "Your program has errors (-30 pts)" >> $REPORT
      ((GRADE = GRADE - 30))
    fi
    rm *.messages 

else                            # Otherwise no py file
  echo "There is no Python file that can be tested (-80 pts)" >> $REPORT
  ((GRADE = GRADE - 80))
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
echo " FINISH ... running student's assignment4 grading"
echo ""

