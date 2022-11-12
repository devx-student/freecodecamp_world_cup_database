#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    TEAM_EXIST=$($PSQL "SELECT team_id from teams where name='$WINNER'")
    if [[ ! $TEAM_EXIST>0 ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    TEAM_EXIST=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
    if [[ ! $TEAM_EXIST>0 ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
    echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi
done
