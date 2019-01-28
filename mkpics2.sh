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
<h1>Pictures</h1>'

# This is part 2 of the static html
html_p2='</body>
</html>'

# This function will take in a column number and also a directory, and it
# will generate the HTML parts of the table appropriately
generate_table() {
COLS=$1
echo "<table>"
while [ "$2" != "" ] # Keep going until everything is accounted for
do
  echo '  <tr>'
  for i in `seq $COLS` # Create specified number of columns
  do
    # We check to make sure the current argument is a JPEG
    stop_marker=0 # Used to determine when to stop going.
    # We keep shifting here until the current arg is a JPEG or empty.
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
echo "</table>"
}

# Check if the column number is valid. This will filter out
# anything that is not a positive number
if echo $COLUMN_NUM | egrep -q $valid_nums
then # Nothing happens if it's valid so the script continues
  true 
else # We print to stderr and exit the script
  echo "Argument 1 is not a valid column number!" 1>&2
  exit 1
fi

# We need to make sure $2 is a directory
if [ ! -d "$2" ]
then
  echo "Argument 2 is not a valid directory!" 1>&2
fi

# If the column number given is 0 we just give a skeleton html file
if [ $COLUMN_NUM -eq 0 ]
then
  echo "$html_p1"
  echo "$html_p2"
  exit 1
fi

echo "$html_p1" # First we echo half the static html

# We will loop through every single file in the given directory
for file in $2/*
do
  if [ -d "$file" ] # We only perform actions on files that are directories
  then
    # This will get the year out of the full path
    # For example Pictures/2012 will just become 2012
    YEAR=`echo $file | rev | cut -d / -f 1 | rev`
    echo "<h2>$YEAR</h2>"
    # We use our function to get the HTML table for this directory
    generate_table $COLUMN_NUM $file/*
  else
    true
  fi
done

echo "$html_p2" # Finally we echo the second half of the static html
