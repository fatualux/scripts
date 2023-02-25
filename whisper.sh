#!/bin/sh
# This script requires the following packages to work properly: dunst, python3, python-pip ffmpeg
# You have to install the following modules:
# pip install setuptools-rust
# pip install git+https://github.com/openai/whisper.git
# To update whispeer: pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git
# See docs at https://github.com/openai/whisper


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

ListLanguages() {
  echo "Select the language using up/down keys and enter to confirm:"
  echo
  options=("English" "French" "Spanish" "German" "Italian" "Japanese" "Hindi" "Russian" "Chinese")
  select_option "${options[@]}"
  lang=$?
  # Use the case statement to perform different actions based on the user's input
  case $lang in
    0)
      echo "You selected English"
      LANG="English"
      ;;
    1)
        echo "You selected French"
      LANG="French"
      ;;
    2)
      echo "You selected Spanish"
      LANG="Spanish"
      ;;
    3)
      echo "You selected German"
      LANG="German"
      ;;
    4)
      echo "You selected Italian"
      LANG="Italian"
      ;;
    5)
      echo "You selected Japanese"
      LANG="Japanese"
      ;;
    6)
      echo "You selected Hindi"
      LANG="Hindi"
      ;;
    7)
      echo "You selected Russian"
      LANG="Russian"
      ;;
    8)
      echo "You selected Chinese"
      LANG="Chinese"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export LANG
}

ListDevices() {
  echo "Select the device using up/down keys and enter to confirm:"
  echo
  options=("CUDA" "CPU")
  select_option "${options[@]}"
  device=$?
  # Use the case statement to perform different actions based on the user's input
  case $device in
    0)
      echo "You selected CUDA"
      DEVICE="cuda"
      ;;
    1)
      echo "You selected CPU"
      DEVICE="cpu"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export DEVICE
}

ListModels() {
  echo "Select the model using up/down keys and enter to confirm:"
  echo
  options=("tiny" "base" "small" "medium" "large")
  # Display the list of choices to the user
  select_option "${options[@]}"
  model=$?
  # Use the case statement to perform different actions based on the user's input
  case $model in
    0)
      echo "You selected tiny"
      MODEL="tiny"
      ;;
    1)
      echo "You selected base"
      MODEL="base"
      ;;
    2)
      echo "You selected small"
      MODEL="small"
      ;;
    3)
      echo "You selected medium"
      MODEL="medium"
      ;;
    4)
      echo "You selected large"
      MODEL="large-v2"
      DEVICE="cuda"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export MODEL
}

# List tasks
ListTasks() {
  echo "Select the task using up/down keys and enter to confirm:"
  echo
  options=("translate" "transcribe")
  select_option "${options[@]}"
  task=$?
  # Use the case statement to perform different actions based on the user's input
  case $task in
    0)
      echo "You selected translate"
      TASK="translate"
      ;;
    1)
      echo "You selected transcribe"
      TASK="transcribe"
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
  # Export the user's input variable
  export TASK
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

/bin/dunstify '.:Whisper:.'

SelectFile
ListLanguages
ListDevices
ListModels
ListTasks

IFS=$'\n'
for FILE in $(cat files.txt);
do
  whisper "$FILE" --language "$LANG" --model "$MODEL" --model_dir $HOME/.cache/whisper/ --device "$DEVICE" --task "$TASK"
done
rm files.txt
echo "Done!"
