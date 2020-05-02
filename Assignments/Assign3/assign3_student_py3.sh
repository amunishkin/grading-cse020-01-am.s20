#!/bin/bash
# assignment3.sh - grades assignment3 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

echo ""
echo " START ... running student's assignment3 grading"
echo ""
#################################################

SOURCES="ModifyShoppingChart.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "============================" > $REPORT
echo "|| Grade Book for assign3 ||" >> $REPORT
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
    MAX_CNT=100
    ###################################
    # Run1:  
    cat run1.txt | python3 $name &> run1.messages
    grep -E "[Cc]ome again" run1.messages > run1.out
    #----------------------------------
    # Run2: 
    cat run2.txt | python3 $name &> run2.messages
    grep -E "[Cc]ome again" run2.messages > run2.out
    #----------------------------------
    # Run3: 
    cat run3.txt | python3 $name &> run3.messages
    CNT=$(grep -cE "[Ss]orry we don't have" run3.messages | grep -oE "[0-9]+")
    if ((CNT == 2)); then
      echo "Handled buying items **not** in store" > run3.txt
      cat run3.txt
    fi
    #----------------------------------
    # Run4: let's make sure shopping store logic works out
    cat run4.txt | python3 $name &> run4.messages
    ROUNDS=$(grep -cE "[Cc]ontinue shopping" run4.messages | grep -oE "[0-9]+")
    CNT=$(grep -cE "[4.95]" run4.messages | grep -oE "[0-9]+")
    if ((ROUNDS > 1)) && ((CNT > 1)); then
      echo "At least two rounds with costs! Took $cnt" > run4.out
      cat run4.out
    fi
    #----------------------------------
    # Run5: let's try to get a discount... could be random
    for ((cnt=1; cnt<=MAX_CNT; cnt++)); do # based on example_output.txt should
                                           #  statistically should take 10 buys
      cat run4.txt | python3 $name &> run5.messages
      grep -E "[Cc]ongratulations" run5.messages > run5.out
      if [ -s run5.out ]; then
        echo "Discount found at $cnt"
        break # Ok, found discount
      fi
      if ((cnt == MAX_CNT)); then
        echo "Please rerun -- test not accurate"
      fi
    done
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
    grep "[Ee]rror" run2.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run3.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run4.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run5.messages | grep -v "EOFError" >> err.messages
      
    echo "" >> $REPORT
    # print code run
    echo "---------- python run1 -----------" >> $REPORT
    echo "python3 $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run1.messages >> $REPORT
    echo "---------- python run2 -----------" >> $REPORT
    echo "python3 $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run2.messages >> $REPORT
    echo "---------- python run3 -----------" >> $REPORT
    echo "python3 $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run3.messages >> $REPORT
    echo "---------- python run4 -----------" >> $REPORT
    echo "python3 $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run4.messages >> $REPORT
    echo "---------- python run5 -----------" >> $REPORT
    echo "python3 $basename" >> $REPORT
    #echo "" >> $REPORT
    grep -n "" run5.messages >> $REPORT
    echo "----------------------------------" >> $REPORT
    #

    # check run1 output: 
    if [ ! -s run1.out ]; then
      echo "Found no exit message in Run1 (-5 pts)" >> $REPORT
      ((GRADE = GRADE - 5))
    fi
    # check run2 output: 
    if [ ! -s run2.out ]; then
      echo "Found no exit message in Run2 (-5 pts)" >> $REPORT
      ((GRADE = GRADE - 5))
    fi
    # check run3 output: 
    if [ ! -s run3.out ]; then
      echo "Make sure you handle buying items **not** in the store in Run3 (-15 pts)" >> $REPORT
      ((GRADE = GRADE - 15))
    fi
    # check run4 output: 
    if [ ! -s run4.out ]; then
      echo "Make sure you handle buying items in the store in Run4 (-15 pts)" >> $REPORT
      ((GRADE = GRADE - 15))
    fi
    # check run5 output: 
    if [ ! -s run5.out ]; then
      echo "Couldn't find discounted item in the store in Run5 (-10 pts)" >> $REPORT
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
echo " FINISH ... running student's assignment3 grading"
echo ""

