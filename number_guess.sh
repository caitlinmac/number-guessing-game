#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

#randomly generate a number
RANDOM_NO=$(( $RANDOM%1000 ))
echo $RANDOM_NO

#prompt user for username
echo Enter your username:
read USERNAME_ENTERRED

#check database for that username
USERNAME_CHECK=$($PSQL "SELECT * FROM players_stats WHERE username='$USERNAME_ENTERRED';")

#if username query is blank (username does not exist in database)
if [[ -z $USERNAME_CHECK ]]
then
  #add user to db
  ADD_NEW_USER=$($PSQL "INSERT INTO players_stats(username) VALUES('$USERNAME_ENTERRED');")
  #welcome message to new user using the username you just added to the db
  echo Welcome, "$($PSQL "SELECT username FROM players_stats WHERE username='$USERNAME_ENTERRED';")"! It looks like this is your first time here. 

#if username query returns result
else
  #welcome back existing user and display games played and best score
  echo "Welcome back, $($PSQL "SELECT username FROM players_stats WHERE username='$USERNAME_ENTERRED';")! You have played $($PSQL "SELECT games_played FROM players_stats WHERE username='$USERNAME_ENTERRED';") games, and your best game took $($PSQL "SELECT best_game FROM players_stats WHERE username='$USERNAME_ENTERRED';") guesses."
fi

#THE GAME
echo Guess the secret number between 1 and 1000:

##start loop here
for (( i=1; i<1000; i++ ))
do
  GUESS_COUNT=$i
  read GUESS

  #if not int = guess again
  if [[ ! $GUESS =~ [0-9]+ ]]
  then
    echo "That is not an integer, guess again:"

  #if equal to number, you win!
  elif [[ $GUESS == $RANDOM_NO ]]
  then 
    echo You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NO. Nice job!
  
  #check if score is better than previous 
    #if no previous, set current as best score
    if [[ -z $BEST_GAME ]]
    then
      FIRST_SCORE=$($PSQL "UPDATE players_stats SET best_game=$GUESS_COUNT WHERE username='$USERNAME_ENTERRED';")

    #if current is lower than db score, replace with current
    elif [[ $GUESS_COUNT -lt $BEST_GAME ]]
    then 
      NEW_HIGH_SCORE=$($PSQL "UPDATE players_stats SET best_game=$GUESS_COUNT WHERE username='$USERNAME_ENTERRED';")
    fi
    
    #add +1 to current game count query and update database
    CURRENT_GAME_COUNT=$($PSQL "SELECT games_played FROM players_stats WHERE username='$USERNAME_ENTERRED';")
    NEW_GAME_COUNT=$(( $CURRENT_GAME_COUNT + 1 ))
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