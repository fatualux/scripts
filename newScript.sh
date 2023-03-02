#! /bin/bash
#This script creates a bash script template according to the chosen name, description and dependencies.
#It depends on: bash

################################ FUNCTIONS ################################

ReadInput(){
  echo ""
  echo "Insert a name for the new script:"
  echo ""
  read NAME
  echo ""
  echo "Insert a description for the new script:"
  echo ""
  read DESCRIPTION
  echo ""
  echo "Insert the dependencies of this script:"
  echo ""
  read DEPENDENCIES
  export NAME
  export DESCRIPTION
  export DEPENDENCIES
}

################################# SCRIPT ##################################

ReadInput

S_PATH="$HOME/.scripts"
SCRIPT="$S_PATH/$NAME.sh"
HEADER="#!/bin/bash"

touch $SCRIPT && chmod +x $SCRIPT
echo -e $HEADER > $SCRIPT
echo -e "#This script ""$DESCRIPTION" >> $SCRIPT
echo -e "#It depends on: ""$DEPENDENCIES" >> $SCRIPT
echo "" >> $SCRIPT

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
