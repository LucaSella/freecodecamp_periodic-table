#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE $1=atomic_number")
  else
    ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE '$1'=symbol OR '$1'=name;")
  fi

  if [[ -z $ELEMENT_INFO_RESULT ]]
  then
    echo "I could not find that element in the database."
  else 
    echo $ELEMENT_INFO_RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME AMU MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AMU amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
