#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "truncate table games,teams")"
cat games.csv|while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
  WINNER_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
  if [[ -z $WINNER_TEAM ]]
  then
    WINNER_INSERT="$($PSQL "insert into teams(name) values ('$WINNER') ")"
    if [[ $WINNER_INSERT == "INSERT 0 1" ]]
    then
      echo "Insert $WINNER successfully"
    else 
      echo "Insert fail" 
    fi   
  else
    echo "Name have existed"
  fi
  OPPONENT_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
  if [[ -z $OPPONENT_TEAM ]]
  then
    OPPONENT_INSERT="$($PSQL "insert into teams(name) values ('$OPPONENT') ")"
    if [[ $OPPONENT_INSERT == "INSERT 0 1" ]]
    then
      echo "Insert $OPPONENT successfully"
    else 
      echo "Insert fail" 
    fi   
  else
    echo "Name have existed"
  fi

  WINNER_ID="$($PSQL "select team_id from teams where name='$WINNER' ")"
  OPPONENT_ID="$($PSQL "select team_id from teams where name='$OPPONENT' ")"
  INSERT_GAMES="$($PSQL "insert into games(winner_id,opponent_id,year,round,winner_goals,opponent_goals) values($WINNER_ID,$OPPONENT_ID,$YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS)")"
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then
    echo Game data inserted Successfully!
  else 
    echo Failed to insert game data!
  fi
fi
done    