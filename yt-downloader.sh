#!/bin/sh
#This script requires the following packages to work properly: dunst yt-dlp ffmpeg zenity

/bin/dunstify '.:Youtube-Downloader:.'

################################ FUNCTIONS ################################
# creates a list of options selectable by the arrow keys
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

ListActions() {
  echo "Select the action using up/down keys and enter to confirm:"
  echo
  options=("Download a video" "Extract the audio from a video" "Convert a media file" "Download video playlist" "Download audio playlist")
  select_option "${options[@]}"
  action=$?
  # Use the case statement to perform different actions based on the user's input
  case $action in
    0)
      echo "You selected Download a video"
      ACTION="download"
      ;;
    1)
        echo "You selected Extract the audio from a video"
      ACTION="extract"
      ;;
    2)
      echo "You selected Convert a media file"
      ACTION="convert"
      ;;
    3)
      echo "You selected Download video playlist"
      ACTION="v_playlist"
      ;;
    4)
      echo "You selected Download audio playlist"
      ACTION="a_playlist"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export ACTION
}

ListFormats() {
  echo "Select the format using up/down keys and enter to confirm:"
  echo
  options=(" mp4" " mkv" " avi" " m4a" " flv" " webm")
  select_option "${options[@]}"
  media_format=$?
  # Use the case statement to perform different actions based on the user's input
  case $media_format in
    0)
      echo "You selected mp4"
      M_FORMAT="mp4"
      ;;
    1)
      echo "You selected mkv"
      M_FORMAT="mkv"
      ;;
    2)
      echo "You selected avi"
      M_FORMAT="avi"
      ;;
    3)
      echo "You selected m4a"
      M_FORMAT="m4a"
      ;;
    4)
      echo "You selected flv"
      M_FORMAT="flv"
      ;;
    5)
      echo "You selected webm"
      M_FORMAT="webm"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export M_FORMAT
}

ListAudioFormats() {
  echo "Select the audio format using up/down keys and enter to confirm:"
  echo
  options=("mp3" "flac" "wav")a
  select_option "${options[@]}"
  audio_format=$?
  # Use the case statement to perform different actions based on the user's input
  case $audio_format in
    0)
      echo "You selected mp3"
      AUDIO_FORMAT="mp3"
      ;;
    1)
      echo "You selected flac"
      AUDIO_FORMAT="flac"
      ;;
    2)
      echo "You selected wav"
      AUDIO_FORMAT="wav"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export AUDIO_FORMAT
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
