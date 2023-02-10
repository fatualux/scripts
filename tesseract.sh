#!/bin/sh
# This script requires the following packages to work properly: dunst, tesseract (https://github.com/tesseract-ocr/tesseract), zenity (https://github.com/matthew-brett/zenity)

################################ FUNCTIONS ################################

ListLanguages() {
  # Display the list of choices to the user
  echo ""
  echo "Choose the language to recognize:"
  echo "1. English"
  echo "2. Italian"
  echo "3. French"
  echo "4. Spanish"
  echo "5. Russian"
  echo "6. German"
  echo "7. Chinese"
  echo "8. Japanese"
  echo "9. Hindi"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  # Use the if statement to perform different actions based on the user's input
  if [ "$choice" = "1" ]; then
    echo "You selected English."
    LANG="eng"
  elif [ "$choice" = "2" ]; then
    echo "You selected Italian"
    LANG="ita"
  elif [ "$choice" = "3" ]; then
    echo "You selected French"
    LANG="fra"
  elif [ "$choice" = "4" ]; then
    echo "You selected Spanish"
    LANG="spa"
  elif [ "$choice" = "5" ]; then
    echo "You selected Russian"
    LANG="rus"
  elif [ "$choice" = "6" ]; then
    echo "You selected German"
    LANG="deu"
  elif [ "$choice" = "7" ]; then
    echo "You selected Chinese"
    LANG="chi-tra"
  elif [ "$choice" = "8" ]; then
    echo "You selected Japanese"
    LANG="jpn"
  elif [ "$choice" = "9" ]; then
    echo "You selected Hindi"
    LANG="hin"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export LANG
}

# List output formats
ListOutputs() {
  # Display the list of choices to the user
  echo ""
  echo "Choose a task:"
  echo "1. PDF"
  echo "2. TXT"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  if [ "$choice" = "1" ]; then
    echo "You selected pdf."
    OUTPUT="pdf"
  elif [ "$choice" = "2" ]; then
    echo "You selected txt"
    OUTPUT="txt"
  else
    echo "Invalid selection"
  fi
  # Export the user_input variable
  export OUTPUT
}

SelectFile() {
  files=$(zenity --title "Which file do you want to transcribe?"  --file-selection --multiple --filename=$HOME/)
  [[ "$files" ]] || exit 1
  echo $files | tr "|" "\n" | while read file
  do
    echo "$file" >> files.txt
  done
}
################################## SCRIPT ##################################

/bin/dunstify '.:Tesseract:.'

SelectFile
ListLanguages
ListOutputs

IFS=$'\n'
for FILE in $(cat files.txt);
do
  tesseract "$FILE" "$FILE" "$OUTPUT" -l "$LANG"
done
rm files.txt
echo "Done!"
