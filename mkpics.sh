#! /bin/sh

COLUMN_NUM=$1 # Set the number of columns as a variable to use

valid_nums='^[0-9]+$' # Used to make sure first arg is a positive int

# This is part 1 of the static html
html_p1='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Pictures</title>
</head>
<body>
<h1>Pictures</h1>
<table>'

# This is part 2 of the static html
html_p2='</table>
</body>
</html>'

# Check if the column number is valid. This will filter out
# anything that is not a positive number
if echo $COLUMN_NUM | egrep -q $valid_nums
then # Nothing happens if it's valid so the script continues
  true 
else # We print to stderr and exit the script
  echo "Column number is not valid!" 1>&2
  exit 1
fi

# If the column number given is 0 we just give a skeleton html file
if [ $COLUMN_NUM -eq 0 ]
then
  echo "$html_p1"
  echo "$html_p2"
  exit 1
fi

# At this point we know column number isn't 0
echo "$html_p1" # First we echo half the static html

# We now start putting the images into our html. Every time the 
# while loop is run we'll create one table row with the specified
# number of columns.
while [ "$2" != "" ]
do
  echo '  <tr>'
  for i in $(seq $COLUMN_NUM) # Create specified number of columns
  do


    # We check to make sure the current argument is a JPEG
    stop_marker=0
    while test $stop_marker -ne 1
    do
      if test ! -z "$2"
      then
        if `file "$2" | grep -q 'JPEG'`
        then
          stop_marker=1
        else
          echo "${2} is not a JPEG file!" 1>&2
          shift
        fi
      else
        stop_marker=1
      fi
    done



    # This if statement prevents our script from making empty
    # column cells
    if [ "$2" != "" ]
    then
      echo '    <td><img src="'$2'" height=100></td>'
      shift
    fi
  done
  echo '  </tr>'
done

echo "$html_p2" # Finally we echo the second half of the static html