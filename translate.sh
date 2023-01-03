#! /bin/bash
#This script requires the following packages to work properly: dunst translate-shell

/bin/dunstify ".:TRANSLATOR:."

# List some of the available languages
ListLanguages() {
  # Display the list of choices to the user
  echo ""
  echo "Chose a language:"
  echo "1. English"
  echo "2. Italian"
  echo "3. Spanish"
  echo "4. French"
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
  LANG="en"
elif [ "$choice" = "2" ]; then
  echo "You selected Italian"
  LANG="it"
elif [ "$choice" = "3" ]; then
  echo "You selected Spanish"
  LANG="es"
elif [ "$choice" = "4" ]; then
  echo "You selected French"
  LANG="fr"
else
  echo "Invalid selection"
fi

echo ""
echo "Word or phrase?"

read -r TERM
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
