#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams restart identity;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 #SKIP THE HEADER LINE
 if [[ $YEAR != "year" ]]
 then
  # INSERT THE WINNER TEAM IF IT DOES NOT EXIST
  WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into teams, $WINNER"
    fi
  fi

  # INSERT THE OPPONENT TEAM IF IT DOES NOT EXIST
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_OPPONENT_REULT == "INSERT 0 1" ]]
    then
      echo "Inserted into teams, $OPPONENT"
    fi
  fi

  # Set the values of WINNER_ID and OPPONENT_ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
  then
    echo "Inserted into games: $YEAR, $ROUND, $WINNER vs. $OPPONENT"
  fi
fi

done


