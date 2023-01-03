#!/bin/sh
#This script requires the following packages to work properly: dunst yt-dlp

/bin/dunstify '.:Youtube-Downloader:.'

COLS=$(tput cols)
text="Insert video URL:"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"

read -r URL

yt-dlp --all-formats --get-file "$URL"

# List video formats
ListFormats() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a format:"
  echo "1. mp3"
  echo "2. mp4"
  echo "3. mkv"
  echo "4. avi"
  echo "5. webm"
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
  M_FORMAT="mp3"
elif [ "$choice" = "2" ]; then
  echo "You selected mp4"
  M_FORMAT="mp4"
elif [ "$choice" = "3" ]; then
  echo "You selected mkv"
  M_FORMAT="mkv"
elif [ "$choice" = "4" ]; then
  echo "You selected avi"
  M_FORMAT="avi"
elif [ "$choice" = "5" ]; then
  echo "You selected webm"
  M_FORMAT="webm"
else
  echo "Invalid selection"
fi

COLS=$(tput cols)
text="Which name for the output file?"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"

read -r NAME

yt-dlp -o "$NAME"".$M_FORMAT" -f "$M_FORMAT" -i --hls-prefer-ffmpeg --print-traffic "$URL"

# List video formats
ListFormats() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a format, or press Enter to quit:"
  echo "1. mp3"
  echo "2. mp4"
  echo "3. mkv"
  echo "4. avi"
  echo "5. webm"
  # Read the user's input and save it in a variable
  read -p "Which format for the downloaded media? " choice

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
  echo "You selected webm"
  FORMAT=".webm"
else
  echo "exit"
fi

ffmpeg -i "$NAME"".$M_FORMAT" "$NAME""$FORMAT"
