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
    # Run1: lose on purpose so can check if Bot wins
    for cnt in {1..100}; do # statistically should take 10 tries
                            #  but we add more just to be safe...
      cat run1.txt | python $name &> run1.messages
      grep -v "Player" run1.messages | grep "WON" > run1.out
      if [ -s run1.out ]; then
        echo "Bot won at $cnt"
        break # Ok, found that Bot WON
      fi
    done
    #----------------------------------
    # Run2: let's try to win! Brute force it
    for cnt in {1..500}; do # on worse case, should take 7 tries
                            #  statistically only one of 10, Bot wins
      cat run2.txt | python $name &> run2.messages
      grep "Player" run2.messages | grep "WON" > run2.out
      if [ -s run2.out ]; then
        echo "Player won at $cnt"
        break # Ok, found that Player WON
      fi
    done
    #----------------------------------
    # Run3: let's make sure game logic works out
    cat run1.txt | python $name &> run3.messages
    ROUNDS=$(grep -c "Bot: My turn..." run3.messages | grep -oE "[0-9]+")
    if ((ROUNDS > 1)); then
      echo "At least two rounds!" > run3.out
      cat run3.out
    fi
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
    grep "[Ee]rror" run2.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run3.messages | grep -v "EOFError" >> err.messages
      
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
    if [ ! -s run1.out ]; then
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

