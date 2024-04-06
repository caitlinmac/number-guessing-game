#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

#randomly generate a number
RANDOM_NO=$(( $RANDOM%1000 ))
echo $RANDOM_NO
#users have to guess that number
## prompt user for username
echo Enter your username:
read USERNAME_ENTERRED
#echo enterred $USERNAME_ENTERRED
## check database for that username
USERNAME_CHECK=$($PSQL "SELECT * FROM players_stats WHERE username='$USERNAME_ENTERRED';")
#echo $USERNAME_CHECK
  #IFS=$'|' #<-- this was causing a lot of problems before! big bug fix here, -t in the PSQL above means that it is tab delimited.
  ##^^ okay except now its needed? ugh
#echo "$USERNAME_CHECK" | while read USER_ID BAR USERNAME BAR GAMES_PLAYED BAR BEST_GAME
#do
  #echo "new var" $USERNAME $GAMES_PLAYED $BEST_GAME
#done


if [[ -z $USERNAME_CHECK ]]
then
  #if username query is blank
  #add user to db
  ADD_NEW_USER=$($PSQL "INSERT INTO players_stats(username) VALUES('$USERNAME_ENTERRED');")

  #welcome message to new user using the username you just added to the db
  echo Welcome, "$($PSQL "SELECT username FROM players_stats WHERE username='$USERNAME_ENTERRED';")"! It looks like this is your first time here. 

else
  ## display games_played and best_game

  #IFS=$'|'
  #echo $USERNAME_CHECK | while read USER_ID USERNAME GAMES_PLAYED BEST_GAME
  #do
  # echo "new var" $USERNAME $GAMES_PLAYED $BEST_GAME
  # echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  #done
  echo "Welcome back, $($PSQL "SELECT username FROM players_stats WHERE username='$USERNAME_ENTERRED';")! You have played $($PSQL "SELECT games_played FROM players_stats WHERE username='$USERNAME_ENTERRED';") games, and your best game took $($PSQL "SELECT best_game FROM players_stats WHERE username='$USERNAME_ENTERRED';") guesses."
fi

#THE GAME
echo Guess the secret number between 1 and 1000:

##start loop here
for (( i=1; i<1000; i++ ))
do
  GUESS_COUNT=$i
  read GUESS
  #echo Guess number $GUESS_COUNT

  #if not int = redo
  if [[ ! $GUESS =~ [0-9]+ ]]
  then
    echo "That is not an integer, guess again:"

  #if equal to number, you win!
  elif [[ $GUESS == $RANDOM_NO ]]
  then 
    echo You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NO. Nice job!
  #check if score is better than previous 
    ## if no previous, set current as best score
    if [[ -z $BEST_GAME ]]
    then

    FIRST_SCORE=$($PSQL "UPDATE players_stats SET best_game=$GUESS_COUNT WHERE username='$USERNAME_ENTERRED';")

    elif [[ $GUESS_COUNT -lt $BEST_GAME ]]
    then 
      #echo $GUESS_COUNT is better than 
      NEW_HIGH_SCORE=$($PSQL "UPDATE players_stats SET best_game=$GUESS_COUNT WHERE username='$USERNAME_ENTERRED';")
    fi
      #add to game counter
      CURRENT_GAME_COUNT=$($PSQL "SELECT games_played FROM players_stats WHERE username='$USERNAME_ENTERRED';")
      #echo current game count $CURRENT_GAME_COUNT
      NEW_GAME_COUNT=$(( $CURRENT_GAME_COUNT + 1 ))
      #echo new game count $NEW_GAME_COUNT
      UPDATE_GAME_COUNT=$($PSQL "UPDATE players_stats SET games_played=$NEW_GAME_COUNT WHERE username='$USERNAME_ENTERRED';")
      #exit loop
      i=$(( $i + 1000 ))

  #if less than number, echo and +1 on the guess counter
  elif [[ $RANDOM_NO -lt $GUESS ]]
  then
    echo "It's lower than that, guess again:"
    

  #if greater than number, echo and +1 on the guess counter
  else [[ $RANDOM_NO -gt $GUESS ]]
    echo "It's higher than that, guess again:"
    
  fi

done