#! /bin/bash
#This script requires the following packages to work properly: dunst translate-shell

/bin/dunstify ".:TRANSLATOR:."

COLS=$(tput cols)
text="Word or phrase?"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"

read -r term

echo Translating...

trans -no-play -v -t it -b "$term"
