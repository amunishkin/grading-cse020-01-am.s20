#!/bin/bash
# lab04.sh - grades lab4 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's lab4 grading"
echo ""
#################################################

SOURCES="CountingBeans_part2.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "=========================" > $REPORT
echo "|| Grade Book for lab4 ||" >> $REPORT
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
    # Run:
    python $name &> run.messages
    ###################################
    #trap '-'
    grep "[Ee]rror" run.messages > err.messages
      
    # print code run
    echo "---------- python run ------------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run.messages >> $REPORT
    echo "----------------------------------" >> $REPORT
    #

    BEAN_TOL=3
    # check half-gallon size output
    BEAN_CNT=$(grep "half" run.messages | grep -oE "[0-9]+")
    if ((BEAN_CNT > 1765)) && ((BEAN_CNT-1765 > BEAN_TOL)); then
      echo "half-gallon's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 1765)) && ((1765-BEAN_CNT > BEAN_TOL)); then
      echo "half-gallon's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check quart size output
    BEAN_CNT=$(grep "quart" run.messages | grep -oE "[0-9]+")
    if ((BEAN_CNT > 883)) && ((BEAN_CNT-883 > BEAN_TOL)); then
      echo "quart's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 883)) && ((883-BEAN_CNT > BEAN_TOL)); then
      echo "quart's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check pint size output
    BEAN_CNT=$(grep "pint" run.messages | grep -oE "[0-9]+")
    if ((BEAN_CNT > 442)) && ((BEAN_CNT-442 > BEAN_TOL)); then
      echo "pint's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 442)) && ((442-BEAN_CNT > BEAN_TOL)); then
      echo "pint's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check cup size output
    BEAN_CNT=$(grep "cup" run.messages | grep -oE "[0-9]+")
    if ((BEAN_CNT > 221)) && ((BEAN_CNT-221 > BEAN_TOL)); then
      echo "cup's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif ((BEAN_CNT < 221)) && ((221-BEAN_CNT > BEAN_TOL)); then
      echo "cup's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
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
echo " FINISH ... running student's lab4 grading"
echo ""

