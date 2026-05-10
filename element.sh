#! /bin/bash

function MAIN() {
  if [[ "$#" != "1" ]]; then
    echo "Please provide an element as an argument."
  else
    MAIN_WITHOUT_CHECKING_PRECONDITIONS "$@"
  fi
}

function MAIN_WITHOUT_CHECKING_PRECONDITIONS() {
  ATOMIC_NUMBERS=$(QUERY_PSQL "SELECT atomic_number FROM elements ORDER BY atomic_number")
  SYMBOLS=$(QUERY_PSQL "SELECT symbol FROM elements ORDER BY atomic_number")
  NAMES=$(QUERY_PSQL "SELECT name FROM elements ORDER BY atomic_number")
  if $(IS_VALUE_IN_ARRAY "$1" $ATOMIC_NUMBERS); then
    ATOMIC_NUMBER=$1
    SYMBOL=$(QUERY_PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    NAME=$(QUERY_PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$(QUERY_PSQL "SELECT type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$(QUERY_PSQL "SELECT atomic_mass FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT_CELSIUS=$(QUERY_PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT_CELSIUS=$(QUERY_PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  elif $(IS_VALUE_IN_ARRAY "$1" $SYMBOLS); then
    SYMBOL=$1
    ATOMIC_NUMBER=$(QUERY_PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
    NAME=$(QUERY_PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL'")
    TYPE=$(QUERY_PSQL "SELECT type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE symbol = '$SYMBOL'")
    ATOMIC_MASS=$(QUERY_PSQL "SELECT atomic_mass FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE symbol = '$SYMBOL'")
    MELTING_POINT_CELSIUS=$(QUERY_PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE symbol = '$SYMBOL'")
    BOILING_POINT_CELSIUS=$(QUERY_PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE symbol = '$SYMBOL'")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  elif $(IS_VALUE_IN_ARRAY "$1" $NAMES); then
    NAME=$1
    ATOMIC_NUMBER=$(QUERY_PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    SYMBOL=$(QUERY_PSQL "SELECT symbol FROM elements WHERE name = '$1'")
    TYPE=$(QUERY_PSQL "SELECT type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE name = '$1'")
    ATOMIC_MASS=$(QUERY_PSQL "SELECT atomic_mass FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE name = '$1'")
    MELTING_POINT_CELSIUS=$(QUERY_PSQL "SELECT melting_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE name = '$1'")
    BOILING_POINT_CELSIUS=$(QUERY_PSQL "SELECT boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE name = '$1'")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  else
    echo I could not find that element in the database.
  fi
}

function QUERY_PSQL() {
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  echo $($PSQL "$1")
}

function IS_VALUE_IN_ARRAY() {
  for ITEM in "${@:2}"; do
    if [[ "$1" = "$ITEM" ]]; then
      echo true
      exit 0
    fi
  done
  echo false
}

MAIN "$@"