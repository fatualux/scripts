#!/bin/sh

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
  echo "Select one option using up/down keys and enter to confirm:"
  echo
  options=("1. Alarm", "2. Clean Arch", "3. Transcribe media files", "4. OCR transcripion", "5. Translate text", "6. Download/convert media from the Internet")
  select_option "${options[@]}"
  action=$?
  # Use the case statement to perform different actions based on the user's input
  case $action in
    0)
      echo "You chose to set an alarm."
      SCRIPT="alarm.sh"
      ;;
    1)
      echo "You chose CleanArch script."
      SCRIPT="archClean.sh"
      ;;
    2)
      echo "You chose to Transcribe media files."
      SCRIPT="whisper.sh"
      ;;
    3)
      echo "You chose to try an OCR transcripion."
      SCRIPT="tesseract.sh"
      ;;
    4)
      echo "You chose to translate a piece of text."
      SCRIPT="translate.sh"
      ;;
    5)
      echo "You chose to download/convert a media from the Internet."
      SCRIPT="yt-downloader.sh"
      ;;
    *)
      echo "Invalid selection"
      ;;
  esac

  # Export the user's input variable
  export SCRIPT
}

################################## SCRIPT ##################################

/bin/dunstify '.:Script Launcher:.'

ListActions

sh "$SCRIPT"

