#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

#randomly generate a number
RANDOM_NO=$(( $RANDOM%1000 ))
echo $RANDOM_NO
#users have to guess that number
## prompt user for username
echo Enter your username:
read USERNAME_ENTERRED
echo enterred $USERNAME_ENTERRED
## check database for that username
USERNAME_CHECK=$($PSQL "SELECT * FROM players_stats WHERE username='$USERNAME_ENTERRED';")
  #IFS=$'|'
echo "$USERNAME_CHECK" | while read USER_ID USERNAME GAMES_PLAYED BEST_GAME
do
  echo "new var" $USERNAME $GAMES_PLAYED $BEST_GAME
done

if [[ -z $USERNAME_CHECK ]]
then
  #if username query is blank
  #add user to db <-- HAVING ISSUES WITH THIS LINE!!!!!
  ADD_NEW_USER=$($PSQL "INSERT INTO players_stats(username) VALUES('$USERNAME_ENTERRED');")
  #welcome message to new user
  echo Welcome, $USERNAME_ENTERRED! It looks like this is your first time here. 
  #if username query not blank, welcome back
else
  ## display games_played and best_game
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

#THE GAME
echo Guess the secret number between 1 and 1000:

###start loop here?
for (( i=1; i<1000; i++ ))
do
  GUESS_COUNT=$i
  read GUESS
  echo Guess number $GUESS_COUNT

  #if not int = redo
  if [[ ! $GUESS =~ [0-9]+ ]]
  then
    echo "That is not an integer, guess again:"

  #if equal to number, you win!
  elif [[ $GUESS == $RANDOM_NO ]]
  then 
    echo You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NO. Nice job!
  #check if score is better than previous 
    if [[ $GUESS_COUNT -lt $BEST_GAME ]]
    then 
      NEW_HIGH_SCORE=$($PSQL "INSERT INTO players_stats(best_game) VALUES ($GUESS_COUNT) WHERE username='$USERNAME_ENTERRED';")
    fi
      #add to game counter
      CURRENT_GAME_COUNT=$($PSQL "SELECT games_played FROM players_stats WHERE username='$USERNAME_ENTERRED';")
      echo current game count $CURRENT_GAME_COUNT
      NEW_GAME_COUNT=$CURRENT_GAME_COUNT+1
      echo new game count $NEW_GAME_COUNT
      UPDATE_GAME_COUNT = $($PSQL "INSERT INTO players_stats(games_played) VALUES ($NEW_GAME_COUNT) WHERE username='$USERNAME_ENTERRED';")
      #exit loop
      i=1001

  #if less than number, echo and +1 on the guess counter
  elif [[ $RANDOM_NO -lt $GUESS ]]
  then
    echo "It's lower than that, guess again:"
    

  #if greater than number, echo and +1 on the guess counter
  else [[ $RANDOM_NO -gt $GUESS ]]
    echo "It's higher than that, guess again:"
    
  fi
done