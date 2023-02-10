#!/bin/sh
# This script requires the following packages to work properly: dunst, python3, python-pip ffmpeg
# You have to install the following modules:
# pip install setuptools-rust
# pip install git+https://github.com/openai/whisper.git
# To update whispeer: pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git
# See docs at https://github.com/openai/whisper


################################ FUNCTIONS ################################

ListLanguages() {
  # Display the list of choices to the user
  echo ""
  echo "Choose the language of the media to transcribe:"
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
    LANG="English"
  elif [ "$choice" = "2" ]; then
    echo "You selected Italian"
    LANG="Italian"
  elif [ "$choice" = "3" ]; then
    echo "You selected French"
    LANG="French"
  elif [ "$choice" = "4" ]; then
    echo "You selected Spanish"
    LANG="Spanish"
  elif [ "$choice" = "5" ]; then
    echo "You selected Russian"
    LANG="Russian"
  elif [ "$choice" = "6" ]; then
    echo "You selected German"
    LANG="German"
  elif [ "$choice" = "7" ]; then
    echo "You selected Chinese"
    LANG="Chinese"
  elif [ "$choice" = "8" ]; then
    echo "You selected Japanese"
    LANG="Japanese"
  elif [ "$choice" = "9" ]; then
    echo "You selected Hindi"
    LANG="Hindi"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export LANG
}

ListDevices() {
  # Display the list of choices to the user
  echo ""
  echo "Choose a device:"
  echo "1. CUDA"
  echo "2. CPU"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  if [ "$choice" = "1" ]; then
    echo "You selected CUDA."
    DEVICE="cuda"
  elif [ "$choice" = "2" ]; then
    echo "You selected CPU"
    DEVICE="cpu"
  else
    echo "Invalid selection"
  fi
  # Export the user's input variable
  export DEVICE
}

ListModels() {
  # Display the list of choices to the user
  echo ""
  echo "Choose a model:"
  echo "1. tiny"
  echo "2. base"
  echo "3. small"
  echo "4. medium"
  echo "5. large"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  if [ "$choice" = "1" ]; then
    echo "You selected tiny."
    MODEL="tiny"
  elif [ "$choice" = "2" ]; then
    echo "You selected base"
    MODEL="base"
  elif [ "$choice" = "3" ]; then
    echo "You selected small"
    MODEL="small"
  elif [ "$choice" = "4" ]; then
    echo "You selected medium"
    MODEL="medium"
  elif [ "$choice" = "5" ]; then
    echo "You selected large"
    MODEL="large-v2"
    DEVICE="cuda"
  else
    echo "Invalid selection"
  # Export the user's input variable
  export DEVICE
fi
}

# List tasks
ListTasks() {
  # Display the list of choices to the user
  echo ""
  echo "Choose a task:"
  echo "1. Transcribe"
  echo "2. Translate"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice
  if [ "$choice" = "1" ]; then
    echo "You selected transcribe."
    TASK="transcribe"
  elif [ "$choice" = "2" ]; then
    echo "You selected translate"
    TASK="translate"
  else
    echo "Invalid selection"
  fi
  # Export the user_input variable
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
