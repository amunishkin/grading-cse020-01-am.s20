#!/bin/bash
# lab03.sh - grades lab3 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's lab3 grading"
echo ""
#################################################

SOURCES="CountingBeans.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "=========================" > $REPORT
echo "|| Grade Book for lab3 ||" >> $REPORT
echo "=========================" >> $REPORT


echo "" >> $REPORT
#
# checks files ----------------------------------
#
for FILE in $SOURCES; do
  if [ ! -e "$FILE" ]; then
    echo "$FILE absent (-25 pts)" >> $REPORT
    ((GRADE = GRADE - 25))
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
    echo "half" | python $name &> run1.messages
    # Run2:
    echo "quart" | python $name &> run2.messages
    # Run3:
    echo "pint" | python $name &> run3.messages
    # Run4:
    echo "cup" | python $name &> run4.messages
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

    BEAN_TOL=3
    # check run1 output
    BEAN_CNT=$(grep -oE "[0-9]+" run1.messages)
    if ((BEAN_CNT > 1765)) && ((BEAN_CNT-1765 > BEAN_TOL)); then
      echo "Run1's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 1765)) && ((1765-BEAN_CNT > BEAN_TOL)); then
      echo "Run1's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run2 output
    BEAN_CNT=$(grep -oE "[0-9]+" run2.messages)
    if ((BEAN_CNT > 883)) && ((BEAN_CNT-883 > BEAN_TOL)); then
      echo "Run2's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 883)) && ((883-BEAN_CNT > BEAN_TOL)); then
      echo "Run2's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run3 output
    BEAN_CNT=$(grep -oE "[0-9]+" run3.messages)
    if ((BEAN_CNT > 442)) && ((BEAN_CNT-442 > BEAN_TOL)); then
      echo "Run3's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 442)) && ((442-BEAN_CNT > BEAN_TOL)); then
      echo "Run3's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run4 output
    BEAN_CNT=$(grep -oE "[0-9]+" run4.messages)
    if ((BEAN_CNT > 221)) && ((BEAN_CNT-221 > BEAN_TOL)); then
      echo "Run4's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 221)) && ((221-BEAN_CNT > BEAN_TOL)); then
      echo "Run4's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi

    # error messages check
    if [ -s err.messages ]; then
      echo "Your program has errors (-35 pts)" >> $REPORT
      ((GRADE = GRADE - 35))
    fi
    rm *.messages 

  done < py.files
else                            # Otherwise no py file
  echo "There is no Python file that can be tested (-75 pts)" >> $REPORT
  ((GRADE = GRADE - 75))
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
echo " FINISH ... running student's lab3 grading"
echo ""

