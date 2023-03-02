#!/bin/bash
#This script creates an empty workspace according to the chosen name and a respective repository on your Github account.
#It depends on: bash git

################################ FUNCTIONS ################################

ReadInput(){
  echo ""
  echo "Insert a name for the new repository:"
  echo ""
  read NAME
  echo ""
  echo "Insert your github username:"
  echo ""
  read USERNAME
  echo ""
  export NAME
  export USERNAME
}

################################# SCRIPT ##################################

ReadInput

R_PATH="$HOME/Documents/github/$NAME"
ORIGIN="git@github.com:$USERNAME/$NAME.git"
echo "--> Creating a new repository in $R_PATH..."
mkdir -p $R_PATH
cd $R_PATH
echo "--> Git init in $R_PATH..."
git init
echo "--> Creating a new README.md file in $R_PATH..."
touch README.md
git add .
git commit -m "$NAME"
git remote add origin $ORIGIN
git push -u origin master
echo "Repository created!"

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
