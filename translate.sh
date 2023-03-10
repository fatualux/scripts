#!/bin/bash
#This script requires the installation on translate-shell, a command-line translator powered by Google Translate (default),
#Bing Translator, Yandex.Translate, and Apertium (https://github.com/soimort/translate-shell).
#It depends on: bash translate-shell

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
  echo "Select one option using up/down keys and enter to confirm:"
  echo
  options=("English" "French" "Spanish" "German" "Italian" "Japanese" "Russian" "Chinese")
  select_option "${options[@]}"
  lang=$?
  # Use the case statement to perform different actions based on the user's input
  case $lang in
    0)
      echo "You selected English"
      LANG="en"
      ;;
    1)
      echo "You selected French"
      LANG="fr"
      ;;
    2)
      echo "You selected Spanish"
      LANG="es"
      ;;
    3)
      echo "You selected German"
      LANG="de"
      ;;
    4)
      echo "You selected Italian"
      LANG="it"
      ;;
    5)
      echo "You selected Japanese"
      LANG="ja"
      ;;
    6)
      echo "You selected Russian"
      LANG="rus"
      ;;
    7)
      echo "You selected Chinese"
      LANG="zh-TW"
      ;;
  esac

  # Export the user's input variable
  export LANG
}

################################## SCRIPT ##################################

/bin/dunstify ".:TRANSLATOR:."

ListLanguages

echo ""
echo "Word or phrase?"
echo "(Press Ctrl + D when you have done typing, or Ctrl + C to cancel)"
echo ""
echo "________________________________________"
echo ""
read -r -d $'\04' TERM
echo Translating...

trans -no-play -t "$LANG" "$TERM"

echo ""
echo "Press any key to continue"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
exit ;
else
sleep 1
fi
done
