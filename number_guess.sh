#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

#randomly generate a number
RANDOM_NO=$(( $RANDOM%1000 ))
echo $RANDOM_NO
#users have to guess that number
## prompt user for username (22 characters or less?)
## check database for that username
## display games_played and best_game (measured by number of guesses min)
## if username doesnt exist, welcome them 
## play the game: input > higher or lower > new input
## count number of loops
## if not an integer, display message
## when number is guessed, stop counting and display message + store in db

