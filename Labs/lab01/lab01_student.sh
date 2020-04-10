#!/bin/bash
# lab01.sh - grades lab1 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's lab1 grading"
echo ""
#################################################

SOURCES="HelloWorld.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "=========================" > $REPORT
echo "|| Grade Book for lab1 ||" >> $REPORT
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
ls . | grep "[.]py" > py.files 
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
    python $name &> messages
    ###################################
    #trap '-'
    grep -l "Traceback" messages > err.messages
      
    # print code run
    echo "---------- python run -----------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" messages >> $REPORT
    echo "---------------------------------" >> $REPORT
    #

    # error messages check
    if [ -s err.messages ]; then
      echo "Your program has errors (-50 pts)" >> $REPORT
      ((GRADE = GRADE - 50))
    elif [ ! -s messages ]; then
      echo "Your program has no output (-25 pts)" >> $REPORT
      ((GRADE = GRADE - 25))
    fi
    rm messages err.messages

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
echo " FINISH ... running student's lab1 grading"
echo ""

