#!/bin/bash
# lab05.sh - grades lab5 performance and specification
#
# cse20-01 (Beginning Programming in Python) - Spring 2020
#

# global constants -----------------------------
BEAN_TOL=3

# helper functions -----------------------------
find_jar_number() { # $1==jar_type ; $2==num_of_occurances ; $3==file
  STATUS=0
  #
  case "$1" in
    1)
      BEAN_CNT=$(grep -E "[0-9]+" $3 | grep -m 1 "cup" | grep -oE "[0-9]+")
      NUM_OCCURANCES=$(grep -c "$BEAN_CNT")
      #
      echo "...cup: beans=$BEAN_CNT, num_of_times=$NUM_OCCURANCES"
      #
      if ((BEAN_CNT > 221)) && ((BEAN_CNT-221 > BEAN_TOL)); then
        STATUS=1
      elif ((BEAN_CNT < 221)) && ((221-BEAN_CNT > BEAN_TOL)); then
        STATUS=2
      elif (($NUM_OCCURANCES != $2)); then
        STATUS=3
      fi
    ;;
    2)
      BEAN_CNT=$(grep -E "[0-9]+" $3 | grep -m 1 "pint" | grep -oE "[0-9]+")
      NUM_OCCURANCES=$(grep -c "$BEAN_CNT")
      #
      echo "...pint: beans=$BEAN_CNT, num_of_times=$NUM_OCCURANCES"
      #
      if ((BEAN_CNT > 442)) && ((BEAN_CNT-442 > BEAN_TOL)); then
        STATUS=1
      elif ((BEAN_CNT < 442)) && ((442-BEAN_CNT > BEAN_TOL)); then
        STATUS=2
      elif (($NUM_OCCURANCES != $2)); then
        STATUS=3
      fi
    ;;
    3)
      BEAN_CNT=$(grep -E "[0-9]+" $3 | grep -m 1 "quart" | grep -oE "[0-9]+")
      NUM_OCCURANCES=$(grep -c "$BEAN_CNT")
      #
      echo "...quart: beans=$BEAN_CNT, num_of_times=$NUM_OCCURANCES"
      #
      if ((BEAN_CNT > 883)) && ((BEAN_CNT-883 > BEAN_TOL)); then
        STATUS=1
      elif ((BEAN_CNT < 883)) && ((883-BEAN_CNT > BEAN_TOL)); then
        STATUS=2
      elif (($NUM_OCCURANCES != $2)); then
        STATUS=3
      fi
    ;;
    4)
      BEAN_CNT=$(grep -E "[0-9]+" $3 | grep -m 1 "half" | grep -oE "[0-9]+")
      NUM_OCCURANCES=$(grep -c "$BEAN_CNT")
      #
      echo "...half: beans=$BEAN_CNT, num_of_times=$NUM_OCCURANCES"
      #
      if ((BEAN_CNT > 1765)) && ((BEAN_CNT-1765 > BEAN_TOL)); then
        STATUS=1
      elif ((BEAN_CNT < 1765)) && ((1765-BEAN_CNT > BEAN_TOL)); then
        STATUS=2
      elif (($NUM_OCCURANCES != $2)); then
        STATUS=3
      fi
    ;;
  esac
  return $STATUS
}
#-----------------------------------------------

echo ""
echo " START ... running student's lab5 grading"
echo ""
#################################################

SOURCES="CountingBeans_part3.py"

GRADE=100       # keeps track of current grade
GRADE_MAX=100   # static variable - don't update
REPORT=grade.txt  # where grade logs are stored
echo "=========================" > $REPORT
echo "|| Grade Book for lab5 ||" >> $REPORT
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
    cat run1.txt | python3 $name &> run1.messages
    # Run2:
    cat run2.txt | python3 $name &> run2.messages
    # Run3:
    cat run3.txt | python3 $name &> run3.messages
    # Run4:
    cat run4.txt | python3 $name &> run4.messages
    ###################################
    #trap '-'
    grep "[Ee]rror" run1.messages | grep -v "EOFError" > err.messages
    grep "[Ee]rror" run2.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run3.messages | grep -v "EOFError" >> err.messages
    grep "[Ee]rror" run4.messages | grep -v "EOFError" >> err.messages
      
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

    # check run1 output
    grep -oE "[0-9]+" run1.messages > run1.out 
    if [ -s run1.out ]; then
      echo "Run1's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run2 output
    find_jar_number 4 1 run2.messages
    if (($? == 1)); then
      echo "Run2's output is larger than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif (($? == 2)); then
      echo "Run2's output is smaller than $BEAN_TOL beans (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    elif (($? == 3)); then
      echo "Run2's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    grep -oE "[0-9]+" run3.messages > run3.out
    if ((BEAN_CNT > 442)) && ((BEAN_CNT-442 > BEAN_TOL)); then
      echo "Run3's output is not correct (-10 pts)" >> $REPORT
      ((GRADE = GRADE - 10))
    fi
    # check run4 output
    for ((i=1;i<5;i++)); do
      jar=''
      case "$i" in
        1)
          jar='cup'
          echo "Checking $jar output..."
          find_jar_number 1 2 run4.messages # cup
        ;;
        2)
          jar='pint'
          echo "Checking $jar output..." 
          find_jar_number 2 2 run4.messages # pint
        ;;
        3) 
          jar='quart'
          echo "Checking $jar output..."
          find_jar_number 3 1 run4.messages # quart
        ;;
        4)
          jar='half'
          echo "Checking $jar output..."
          find_jar_number 4 3 run4.messages # half
        ;;
      esac
      if (($? == 1)); then
        echo "Run4's output is larger than $BEAN_TOL beans in $jar (-10 pts)" >> $REPORT
        ((GRADE = GRADE - 10))
      elif (($? == 2)); then
        echo "Run4's output is smaller than $BEAN_TOL beans in $jar (-10 pts)" >> $REPORT
        ((GRADE = GRADE - 10))
      elif (($? == 3)); then
        echo "Run4's output is not correct in $jar (-10 pts)" >> $REPORT
        ((GRADE = GRADE - 10))
      fi
      if (($? != 0)); then
        break # found error so exit...
      fi
    done
    rm *.out

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
echo " FINISH ... running student's lab5 grading"
echo ""

