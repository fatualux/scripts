#!/bin/bash
#This script opens a shell prompt, asks user for a text and search that on google.com.
#It depends on: bash w3m

COLS=$(tput cols)
text="What are you looking for?"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"
echo ""
echo ""

read -r QUERY

URL=$(echo -ne "http://www.google.com/search?ie=ISO-8859-1&hl=it&source=hp&q=""$QUERY")

w3m "$URL"
