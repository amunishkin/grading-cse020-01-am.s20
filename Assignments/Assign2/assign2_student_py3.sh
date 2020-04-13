#!/bin/bash
# assignment2.sh - grades assignment2 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

# helper functions -----------------------------
find_fib_square() { # $1==header/end ; $2==body ; $3==file_in ; $4==file_out
  if (($1 == 1)); then
    CNT=$( grep -Ec "[*][[:space:]]" $3 )
    if (( $CNT > 0 )); then
      echo "1" > $4
    fi
  else
    CNT=$( grep -Ec "[*]{$1}[[:space:]]" $3 )
    if (( $CNT > 1 )); then
      echo "2" > $4
    fi
    if [ -s $4 ] && (($2 > 0)); then
      grep -Ec "[*][[:space:]]{$2}[*]" $3 | grep "$2" > $4
    fi
  fi
}

calc_fib_num() { # $1==fib_num to calc
  F1=0 # 1st
  F2=1 # 2nd
  F3=1 # 3rd
  for ((cnt=2; cnt<$1; cnt++)); do
    ((F3 = $F1 + $F2))
    F1=$F2
    F2=$F3
  done
  return $F3
}
#-----------------------------------------------

echo ""
echo " START ... running student's assignment2 grading"
echo ""
#################################################

SOURCES="FibonacciNumbers.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "============================" > $REPORT
echo "|| Grade Book for assign2 ||" >> $REPORT
echo "============================" >> $REPORT


echo "" >> $REPORT
#
# checks files ----------------------------------
#
for FILE in $SOURCES; do
  if [ ! -e "$FILE" ]; then
    echo "$FILE absent (-15 pts)" >> $REPORT
    ((GRADE = GRADE - 15))
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
    # Run1: check drawing 1st Fibonacci Square  
    cat run1.txt | python3 $name &> run1.messages
    find_fib_square 1 0 run1.messages run1.out
    if [ ! -s run1.out ]; then
      echo "Good, no drawing for 1st Fibonacci Square"
    fi
    #----------------------------------
    # Run2: check drawing 4th Fibonacci Square
    cat run2.txt | python3 $name &> run2.messages
    find_fib_square 2 0 run2.messages run2.out
    if [ -s run2.out ]; then
      echo "Good, drawing here for 4th Fibonacci Square"
    fi
    #----------------------------------
    # Run3: check drawing 10th Fibonacci Square
    cat run3.txt | python3 $name &> run3.messages
    find_fib_square 34 32 run3.messages run3.out
    if [ -s run3.out ]; then
      echo "Good, drawing here for 10th Fibonacci Square"
    fi
    #----------------------------------
    # Run4: check drawing 10th Fibonacci Square and all below
    cat run4.txt | python3 $name &> run4.messages
    for ((fib_num=10; fib_num>0; fib_num--)); do
      calc_fib_num $fib_num
      val1=$? # return value from calc_fib_num() above
      val2=$(( $val1 - 2 ))
      find_fib_square $val1 $val2 run4.messages run4.out
      if [ ! -s run4.out ] && (( fib_num>1 )); then
        echo "Didn't draw $fib_num th Fibonacci Square (-5 pts)" >> $REPORT
        ((GRADE = GRADE - 5))
        break # found Fib. Square that wasn't drawn
      else
        echo "$fib_num works out..."
      fi
    done
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
    grep "[Ee]rror" run2.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run3.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run4.messages | grep -v "EOFError" >> err.messages
      
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
    echo "----------------------------------" >> $REPORT
    #

    # check run1 output: 1st Fib. Square
    if [ -s run1.out ]; then
      echo "Drew a Fibonacci Square for 1st (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run2 output: 4th Fib. Square
    if [ ! -s run2.out ]; then
      echo "Incorrect Fibonacci Square for 4th (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run3 output: 10th Fib. Square
    if [ ! -s run3.out ]; then
      echo "Incorrect Fibonacci Square for 10th (-20 pts)" >> $REPORT
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
echo " FINISH ... running student's assignment2 grading"
echo ""

