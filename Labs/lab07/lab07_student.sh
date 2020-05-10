#!/bin/bash
# lab07.sh - grades lab7 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's lab7 grading"
echo ""
#################################################

SOURCES="FileBasics.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "=========================" > $REPORT
echo "|| Grade Book for lab7 ||" >> $REPORT
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

# make sure there is no lab07_out.txt file
if [ -e lab07_out.txt ]; then
  rm lab07_out.txt
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
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
      
    # print code run
    echo "---------- python run1 -----------" >> $REPORT
    echo "python $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run1.messages >> $REPORT
    echo "----------------------------------" >> $REPORT
    #

    # check run1 output
    grep "[^(] Start of Lab07_out text file" run1.messages > run1.out
    if [ ! -s run1.out ]; then
      echo "Run1's output is not correct (-20 pts)" >> $REPORT
      ((GRADE = GRADE - 20))
    fi
    rm run1.out

    # make sure a lab07_out.txt file was created
    if [ ! -e lab07_out.txt ]; then
      echo "Could not find a file called 'lab07_out.txt' (-20 pts)" >> $REPORT
      ((GRADE = GRADE - 20))
    else
      grep "Start of Lab07_out text file" lab07_out.txt > check.out
      if [ ! -s check.out ]; then
        echo "Contents of 'lab07_out.txt' are not same as output of program (-10 pts)" >> $REPORT
        ((GRADE = GRADE - 10))
      fi
      rm check.out
    fi

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
echo " FINISH ... running student's lab7 grading"
echo ""

