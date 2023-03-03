#!/bin/bash
#This script runs Docker Polymath object and works on the content of input folder
#It depends on: bash docker polymath (https://github.com/samim23/polymath)

WORKDIR="$HOME/Documents/github/polymath"

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

ChooseAction() {
  echo "Select the action you want to perform:"
  echo
  options=("Download an audio file" "Split tracks" "Transform to midi" "Quantize a song")
  select_option "${options[@]}"
  ACTION=$?
  # Use the case statement to perform different actions based on the user's input
  case $ACTION in
    0)
        echo ""
        echo "Paste the last part of a YouTube URL:"
        read -r URL
        COMMAND="polymath python /polymath/polymath.py -a $URL"
      ;;
    1)
        echo ""
        echo "Input folder added."
        COMMAND="polymath python /polymath/polymath.py -a /polymath/input/"
      ;;
    2)
        echo ""
        echo "Input folder added."
        echo "Choose a BPM:"
        read -r BPM
        COMMAND="polymath python /polymath/polymath.py -q all -t $BPM -m"
      ;;
    3)
        echo ""
        echo "Input folder added."
        echo "Choose a BPM:"
        read -r BPM
        COMMAND="polymath python /polymath/polymath.py -q all -t $BPM"
      ;;
    *)
      echo "Invalid option"
      ChooseAction
      ;;
  esac
      export COMMAND
}

ChooseAction

DockerRun() {
  docker run \
      -v "$WORKDIR"/processed:/polymath/processed \
      -v "$WORKDIR"/separated:/polymath/separated \
      -v "$WORKDIR"/library:/polymath/library \
      -v "$WORKDIR"/input:/polymath/input \
      $COMMAND
    }

DockerRun

