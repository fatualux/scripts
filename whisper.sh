#!/bin/sh
# This script requires the following packages to work properly: dunst, python3, python-pip ffmpeg
# You have to install the following modules:
# pip install setuptools-rust
# pip install git+https://github.com/openai/whisper.git
# To update whispeer: pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git
# See docs at https://github.com/openai/whisper

/bin/dunstify '.:Whisper:.'

COLS=$(tput cols)
text="Which media do you want to transcribe?"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"

read -r FILE

COLS=$(tput cols)
text="Which language?"
h_text=${#text}
printf "%*s\n" $((COLS/2+h_text/2)) "$text"

# List downloaded language
ListLanguages() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a model:"
  echo "1. English"
  echo "2. Italian"
  echo "3. Spanish"
  echo "4. French"
  echo "5. Autodetect"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice

  # Export the user_input variable
  export choice
}
# Call the function
ListLanguages
# Use the if statement to perform different actions based on the user's input
if [ "$choice" = "1" ]; then
  echo "You selected English."
  LANG="--language English"
elif [ "$choice" = "2" ]; then
  echo "You selected Italian"
  LANG="--language Italian"
elif [ "$choice" = "3" ]; then
  echo "You selected Spanish"
  LANG="--language Spanish"
elif [ "$choice" = "4" ]; then
  echo "You selected French"
  LANG="--language French"
elif [ "$choice" = "5" ]; then
  echo "You selected Autodetect"
  LANG=""
else
  echo "Invalid selection"
fi

# List devices
ListDevices() {
  # Display the list of choices to the user
  echo ""
  echo "Choose a device:"
  echo "1. CUDA"
  echo "2. CPU"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice

  # Export the user_input variable
  export choice
}
# Call the function
ListDevices
# Use the if statement to perform different actions based on the user's input
if [ "$choice" = "1" ]; then
  echo "You selected CUDA."
  DEVICE="cuda"
elif [ "$choice" = "2" ]; then
  echo "You selected CPU"
  DEVICE="cpu"
else
  echo "Invalid selection"
fi

# List downloaded model
ListModels() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a model:"
  echo "1. tiny"
  echo "2. base"
  echo "3. small"
  echo "4. medium"
  echo "5. large"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice

  # Export the user_input variable
  export choice
}
# Call the function
ListModels
# Use the if statement to perform different actions based on the user's input
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
fi

# List tasks
ListTasks() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a task:"
  echo "1. Transcribe"
  echo "2. Translate"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " choice

  # Export the user_input variable
  export choice
}
# Call the function
ListTasks
# Use the if statement to perform different actions based on the user's input
if [ "$choice" = "1" ]; then
  echo "You selected transcribe."
  TASK="transcribe"
elif [ "$choice" = "2" ]; then
  echo "You selected translate"
  TASK="translate"
else
  echo "Invalid selection"
fi

whisper "$FILE" "$LANG" --model "$MODEL" --model_dir $HOME/.cache/whisper/ --device "$DEVICE" --task "$TASK"
