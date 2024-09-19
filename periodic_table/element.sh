#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Check if no argument is provided
if [[ $# == 0 ]]
then
  echo "Please provide an element as an argument."
  exit 
fi


#Check if the input is a number, then search the corresponding atomic_number in properties table
if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$1")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
    exit
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    exit
  fi
fi

#input is not a number
#first query based on Symbol, if not found query based on name
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
if [[ -z $SYMBOL ]]
then
  NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
  if [[ -z $NAME ]]
  then
    echo "I could not find that element in the database."
    exit
  fi 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  exit
else
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'")
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  exit
fi