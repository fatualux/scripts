#!/bin/sh
#This script requires the following packages to work properly: dunst ffmpeg

/bin/dunstify '.:Media-Converterr:.'

COLS=$(tput cols)
text="Insert media to convert:"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"

read -r FILE


# List video formats
ListFormats() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a format:"
  echo "1. mp3"
  echo "2. mp4"
  echo "3. mkv"
  echo "4. avi"
  echo "5. ogg"
  echo "6. wav"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice

  # Export the user_input variable
  export choice
}
# Call the function
ListFormats
# Use the if statement to perform different actions based on the user's input
if [ "$choice" = "1" ]; then
  echo "You selected mp3."
  FORMAT=".mp3"
elif [ "$choice" = "2" ]; then
  echo "You selected mp4"
  FORMAT=".mp4"
elif [ "$choice" = "3" ]; then
  echo "You selected mkv"
  FORMAT=".mkv"
elif [ "$choice" = "4" ]; then
  echo "You selected avi"
  FORMAT=".avi"
elif [ "$choice" = "5" ]; then
  echo "You selected ogg"
  FORMAT=".ogg"
elif [ "$choice" = "5" ]; then
  echo "You selected wav"
  FORMAT=".wav"
else
  echo "Invalid selection"
fi

ffmpeg -i "$FILE" "$FILE""$FORMAT"
