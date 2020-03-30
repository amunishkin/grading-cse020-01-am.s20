#!/bin/bash
# assignment1.sh - grades assignment1 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's assignment1 grading"
echo ""
#################################################

SOURCES="MyNameAndYours.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "============================" > $REPORT
echo "|| Grade Book for assign1 ||" >> $REPORT
echo "============================" >> $REPORT


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
ls * | grep ".[.]py" > py.files 
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
    # Run1: lose on purpose so can check if Bot wins 
    echo "" > run1.messages # clear from previous run
    for cnt in {1..5}; do 
      while read line; do # statistically should take 10 tries
                          #  but we add more just to be safe...
        echo "$line" | python $name &>> run1.messages
        grep "Bot" run1.messages | grep "WON" > run1.out
        if [ -s run1.out ]; then
          break # Ok, found that Bot WON
        fi
      done < run1.txt
      if [ -s run1.out ]; then
        break # Ok, found that Bot WON, from while
      fi
    done
    #----------------------------------
    # Run2: let's try to win! Brute force it
    echo "" > run2.messages # clear from previous run
    for cnt in {1..5}; do
      while read line; do # on worse case, should take 7 tries
        echo "$line" | python $name &>> run2.messages
        grep "Player" run2.messages | grep "WON" > run2.out
        if [ -s run2.out ]; then
          break # Ok, found that Player WON
        fi
      done < run2.txt
      if [ -s run2.out ]; then
        break # Ok, found that Player WON, from while
      fi
    done
    #----------------------------------
    # Run3: let's make sure game logic works out
    echo "" > run3.messages # clear from previous run
    for cnt in {1..5}; do
      while read line; do
        echo "$line" | python $name &>> run3.messages
        grep -c "Bot: My turn..." run3.messages | grep "2" > run3.out
        if [ -s run3.out ]; then
          break # Ok, found at least two rounds...
        fi
      done < run1.txt # use run1's input so don't win
      if [ -s run3.out ]; then
        break # Ok, found at least two rounds, from while
      fi
    done
    ###################################
    #trap '-'
    grep -l "Traceback" run1.messages > err.messages
    grep -l "Traceback" run2.messages >> err.messages
    grep -l "Traceback" run3.messages >> err.messages
      
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
    echo "----------------------------------" >> $REPORT
    #

    # check run1 output: "Bot WON"
    if [ ! -s run1.out]; then
      echo "Didn't handle Bot winning correctly (-15 pts)" >> $REPORT
      ((GRADE = GRADE - 15))
    fi
    # check run2 output: "Player WON"
    if [ ! -s run2.out ]; then
      echo "Didn't handle Player winning correctly (-15 pts)" >> $REPORT
      ((GRADE = GRADE - 15))
    fi
    # check run3 output using run1 input: 
    #  game logic, i.e. at least two rounds
    if [ ! -s run3.out ]; then
      echo "Game logic is not correct (-20 pts)" >> $REPORT
      ((GRADE = GRADE - 20))
    fi
    rm run*.out

    # error messages check
    if [ -s err.messages ]; then
      echo "Your program has errors (-25 pts)" >> $REPORT
      ((GRADE = GRADE - 25))
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
echo " FINISH ... running student's assignment1 grading"
echo ""

