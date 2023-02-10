#!/bin/sh
#This script requires the following packages to work properly: dunst yt-dlp ffmpeg zenity

/bin/dunstify '.:Youtube-Downloader:.'

################################ FUNCTIONS ################################
ListActions() {
  echo ""
  echo "Choose an action to perform:"
  echo "1. Download a video from a given URL"
  echo "2. Extract the audio from a video on the Internet"
  echo "3. Convert a media file into another format"
  echo "4. Download video playlist"
  echo "5. Download audio playlist"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  # if statement to perform different actions based on the user's input
  if [ "$choice" = "1" ]; then
    ACTION="download"
  elif [ "$choice" = "2" ]; then
    ACTION="extract"
  elif [ "$choice" = "3" ]; then
    ACTION="convert"
  elif [ "$choice" = "4" ]; then
    ACTION="v_playlist"
  elif [ "$choice" = "5" ]; then
    ACTION="a_playlist"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export ACTION
}

ListFormats() {
  # Display the list of choices to the user
  echo ""
  echo "Choose a format for the media to download:"
  echo "1. mp4"
  echo "2. mkv"
  echo "3. avi"
  echo "4. m4a"
  echo "5. flv"
  echo "6. webm"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  # Use the if statement to perform different actions based on the user's input
  if [ "$choice" = "1" ]; then
    echo "You selected mp3."
    M_FORMAT="mp4"
  elif [ "$choice" = "2" ]; then
    echo "You selected mp4"
    M_FORMAT="mkv"
  elif [ "$choice" = "3" ]; then
    echo "You selected mkv"
    M_FORMAT="avi"
  elif [ "$choice" = "4" ]; then
    echo "You selected avi"
    M_FORMAT="m4a"
  elif [ "$choice" = "5" ]; then
    echo "You selected m4a"
    M_FORMAT="flv"
  elif [ "$choice" = "6" ]; then
    echo "You selected wav"
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
  echo "Choose a format for the converted media:"
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

SelectFile() {
  files=$(zenity --file-selection --multiple --filename=$HOME/)
  [[ "$files" ]] || exit 1
  echo $files | tr "|" "\n" | while read file
  do
    echo "$file" >> files.txt
  done
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
  echo "Downloading..."
  yt-dlp -o "Media/%(title)s"".$M_FORMAT" -f "$M_FORMAT" -i --hls-prefer-ffmpeg --print-traffic "$URL" --lazy-playlist
  echo "Done!"
fi
if [ "$ACTION" = "extract" ]; then
  echo ""
  echo "AUDIO EXTRACTOR"
  InsertURL
  ListAudioFormats
  yt-dlp --audio-quality "ba" -x --audio-format "$A_FORMAT" "$URL" -o "Media/%(title)s.%(ext)s"
  echo "Done!"
fi
if [ "$ACTION" = "convert" ]; then
  echo ""
  echo "MEDIA CONVERTER"
  SelectFile
  ListFormats
  IFS=$'\n'
  for FILE in $(cat files.txt);
  do
      FILENAME=`basename "${FILE}"`
      echo $FILENAME
      ffmpeg -i "$FILE" "Media/${FILE%.*}.$M_FORMAT";
  done
  rm files.txt
  echo "Done!"
fi
if [ "$ACTION" = "v_playlist" ]; then
  echo ""
  echo "VIDEO PLAYLIST DOWNLOADER"
  InsertURL
  ListFormats
  yt-dlp -f 'bv*[height=1080]+ba' "$URL" -o 'VideoPlaylist/%(title)s.%(ext)s'
  echo "Downloading..."
  echo "Done!"
fi
if [ "$ACTION" = "a_playlist" ]; then
  echo ""
  echo "AUDIO PLAYLIST DOWNLOADER"
  InsertURL
  ListAudioFormats
  yt-dlp --audio-quality "ba" -x --audio-format "$A_FORMAT" "$URL" -o 'AudioPlaylist/%(title)s.%(ext)s'
  echo "Downloading..."
  echo "Done!"
fi
