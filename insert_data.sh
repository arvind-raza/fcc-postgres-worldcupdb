#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get team id for winner
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi

      # get new WINNER_id
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    # get team id for opponent
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi

      # get new OPPONENT_id
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into students, $YEAR:$ROUND:$WINNER_ID:$OPPONENT_ID:$WINNER_GOALS:$OPPONENT_GOALS
    fi
    # insert into games
  fi
done
