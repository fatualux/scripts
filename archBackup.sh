#!/bin/bash
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Affero GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
FILELIST=('.bash_profile' '.bashrc' '.bash_history' '.vimrc' '.xinitrc' '.Xdefaults')
FOLDERLIST=('.config' '.local' '.cache' '.scripts' '.themes' '.fonts' '.w3m' '.ssh')

DOT_TAR="dotconf.tar.gz"
REPO_PKG="repo-pkglist.txt"
AUR_PKG="cust-pkglist.txt"

SCRIPTNAME=$(basename "$0")
VERSION="0.1"
if [[ -z $1 ]]; then
    echo ":: $SCRIPTNAME $VERSION"
    echo ""
    echo "==> Missing argument: PATH"
    echo ""
    echo "Usage:"
    echo ""
    echo "sh $HOME/.scripts/$SCRIPTNAME path/to/store/output"
    echo ""
    exit
fi

set -e

if ! [[ -d $1 ]]; then
    mkdir -p $1
fi

TAR_CONF="$1/$DOT_TAR"
REPO_PKG_LIST="$1/$REPO_PKG"
AUR_PKG_LIST="$1/$AUR_PKG"

# create an archive of common hidden files and folders

if [[ -e "$TAR_CONF" ]]; then
    # remove archive if exist
    rm -f "$TAR_CONF"
fi

TODO=""
for file in ${FILELIST[@]}; do
    if [[ -f $file ]]; then
        TODO+="${file} "
    fi
done

for folder in ${FOLDERLIST[@]}; do
    if [[ -d ${folder} ]]; then
        TODO+="${folder} "
    fi
done

tar -zcvf "$TAR_CONF" $TODO

# list packages from official repo
pacman -Qqen > "$REPO_PKG_LIST"

# list foreign packages (custom e.g. AUR)
pacman -Qqem > "$AUR_PKG_LIST"

echo " ==> Packagelists created!"
echo "   --> $REPO_PKG_LIST"
echo "   --> $AUR_PKG_LIST"
echo ""
echo " ==> Config archive created!"
echo "   --> $TAR_CONF"
echo ""
echo " ==> To install packages from lists run:"
echo "   --> sudo pacman -Syu --needed - < $REPO_PKG"
echo " ==> To restore the configuration files run:"
echo "   --> tar -xzf $DOT_TAR"
echo ""
