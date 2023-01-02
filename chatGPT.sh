#!/bin/sh
#This script requires the following packages to work properly: dunst espeak mbrola-voices-us1 mbrola-voices-it3

/bin/dunstify '.:ChatGPT:.'

COLS=$(tput cols)
text="Any questions?"
h_text=${#text}

printf "%*s\n" $((COLS/2+h_text/2)) "$text"

read -r question

# Set the initial message prompt
prompt="""$question"""

# Set the API key (replace YOUR_API_KEY with your actual API key)
api_key=$(cat $HOME/.scripts/token.txt)

# Set the endpoint URL for the ChatGPT API
endpoint="https://api.openai.com/v1/completions"

# Make a request to the ChatGPT API using curl
response=$(
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" -d "{\"prompt\": \"$prompt\", \"model\": \"text-davinci-003\", \"max_tokens\": 4000, \"temperature\": 1.0}" $endpoint)

# Use jq to parse the JSON response and extract the 'text' field
text=$(echo $response | jq '.choices[]'.text)

# Trim the characters /n/n from the text variable using sed
trimmed=$(echo $text | sed -e 's/\\n\\n//g' -e 's/\"//g' -e 's/\\n/ - /g')

#clear output
clear

center() {
  # Determine the size of the terminal window
  rows=$(tput lines)
  cols=$(tput cols)

  # Split the input text into an array of lines
  IFS='.' read -r -a lines <<< "$1"

  # Calculate the number of lines of text
  num_lines=${#lines[@]}

  # Calculate the vertical padding required to center the text
  padding=$(( (rows - num_lines) / 2 ))

  # Print the required number of newlines to center the text vertically
  for ((i=0; i<padding; i++)); do
    printf '\n'
  done

  # Print each line of text, centering it horizontally
  for line in "${lines[@]}"; do
    printf "%*s\n" $(( (cols - ${#line}) / 2)) "$line"
  done
}

# Print the trimmed response
center "$trimmed"

# Define the function
TTSprompt() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a language:"
  echo "1. Italian"
  echo "2. English"
  # Read the user's input and save it in a variable
  read -p "Enter your selection: " user_input

  # Export the user_input variable
  export user_input
}

# Call the function
TTSprompt

# Use the if statement to perform different actions based on the user's input
if [ "$user_input" = "1" ]; then
  echo "You selected Italian."
  voice="mb-it3"
elif [ "$user_input" = "2" ]; then
  echo "You selected English"
  voice="mb-us1"
else
  echo "Invalid selection"
fi

sleep 3

espeak -v "$voice" -s 115 "$trimmed"
