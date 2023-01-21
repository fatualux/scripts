#!/bin/sh
#This script requires the following packages to work properly: dunst yt-dlp ffmpeg

/bin/dunstify '.:Youtube-Downloader:.'

################################ FUNCTIONS ################################
ListActions() {
  echo ""
  echo "Chose an action to perform:"
  echo "1. Download a video from a given URL"
  echo "2. Extract the audio from a video on the Internet"
  echo "3. Convert a media file into annother format"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  # if statement to perform different actions based on the user's input
  if [ "$choice" = "1" ]; then
    ACTION="download"
  elif [ "$choice" = "2" ]; then
    ACTION="extract"
  elif [ "$choice" = "3" ]; then
    ACTION="convert"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export ACTION
}

ListFormats() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a format:"
  echo "1. mp3"
  echo "2. mp4"
  echo "3. mkv"
  echo "4. avi"
  echo "5. m4a"
  echo "6. wav"
  echo "7. ogg"
  echo "8. flac"
  echo "9. flv"
  echo "10. webm"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
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
    echo "You selected m4a"
    M_FORMAT="m4a"
  elif [ "$choice" = "6" ]; then
    echo "You selected wav"
    M_FORMAT="wav"
  elif [ "$choice" = "7" ]; then
    echo "You selected ogg"
    M_FORMAT="ogg"
  elif [ "$choice" = "8" ]; then
    echo "You selected flac"
    M_FORMAT="flac"
  elif [ "$choice" = "9" ]; then
    echo "You selected flv"
    M_FORMAT="flv"
  elif [ "$choice" = "10" ]; then
    echo "You selected webm"
    M_FORMAT="webm"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export M_FORMAT
}

ListAudioFormats() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a format:"
  echo "1. mp3"
  echo "2. wav"
  echo "3. flac"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  # Use the if statement to perform different actions based on the user's input
  if [ "$choice" = "1" ]; then
    echo "You selected mp3."
    A_FORMAT="mp3"
  elif [ "$choice" = "2" ]; then
    echo "You selected wav"
    A_FORMAT="wav"
  elif [ "$choice" = "3" ]; then
    echo "You selected flac"
    A_FORMAT="flac"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export A_FORMAT
}

InsertURL() {
  echo ""
  echo "Paste a media URL:"
  read -r URL
  # Export the user_input variable
  export URL
}

ChooseName() {
  echo ""
  echo "Enter a name for the file:"
  read -r NAME
  # Export the user_input variable
  export NAME
}

SelectFile() {
  prompt="Please select a file:"
  options=( $(ls -1) )
  PS3="$prompt "
  select FILE in "${options[@]}" "Quit" ; do
      if (( REPLY == 1 + ${#options[@]} )) ; then
          exit
      elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
          echo  "You selected $FILE."
          break
      else
          echo "Invalid option. Try another one."
      fi
  done
  # Export the user_input variable
  export FILE
}

################################## SCRIPT ##################################

ListActions

if [ "$ACTION" = "download" ]; then
  echo ""
  echo "VIDEO DOWNLOADER"
  InsertURL
  echo "Searching for available formats..."
  yt-dlp --all-formats --get-file "$URL"
  ListFormats
  ChooseName
  echo "Downloading..."
  yt-dlp -o "$NAME"".$M_FORMAT" -f "$M_FORMAT" -i --hls-prefer-ffmpeg --print-traffic "$URL" --lazy-playlist
  echo "Done!"
fi
if [ "$ACTION" = "extract" ]; then
  echo ""
  echo "AUDIO EXTRACTOR"
  InsertURL
  ListAudioFormats
  ChooseName
  yt-dlp -f "ba" -x --audio-format "$A_FORMAT" "$URL" -o "$NAME.%(ext)s"
  echo "Done!"
fi
if [ "$ACTION" = "convert" ]; then
  echo ""
  echo "MEDIA CONVERTER"
  SelectFile
  ListFormats
  ChooseName
  ffmpeg -i "$FILE" "$NAME"".$M_FORMAT"
  echo "Done!"
fi
