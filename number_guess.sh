#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

#randomly generate a number
RANDOM_NO=$(( $RANDOM%1000 ))
echo $RANDOM_NO
#users have to guess that number
## prompt user for username
echo Enter your username:
read USERNAME_ENTERRED
## check database for that username
USERNAME_CHECK=$($PSQL "SELECT username, games_played, best_game FROM players_stats WHERE username='$USERNAME_ENTERRED';")
IFS='|'
echo $USERNAME_CHECK | while read USERNAME GAMES_PLAYED BEST_GAME; do
echo $USERNAME $GAMES_PLAYED $BEST_GAME
done

if [[ -z $USERNAME_CHECK ]]
then
#if username query is blank
#add user to db
ADD_NEW_USER=$($PSQL "INSERT INTO players_stats(username) VALUES ('$USERNAME_ENTERRED');")
#welcome message to new user
echo Welcome, $USERNAME_ENTERRED! It looks like this is your first time here. 
#if username query not blank, welcome back
else
echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

## display games_played and best_game (measured by number of guesses min)
## if username doesnt exist, welcome them 
## play the game: input > higher or lower > new input
## count number of loops
## if not an integer, display message
## when number is guessed, stop counting and display message + store in db

