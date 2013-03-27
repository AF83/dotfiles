#!/usr/bin/env sh

REPOSITORY_NAME='AF83/dotfiles'
REPOSITORY_URL="https://github.com/${REPOSITORY_NAME}"

# Get file list over HTTP.
FILES=`curl -s $REPOSITORY_URL | grep js-directory-link | sed "s/.* title=\"\(.*\)\".*/\1/"`

update_dotfile() {
	FILE=$1
	echo "Getting latest version of $FILE from ${REPOSITORY_NAME}."
	wget -c "https://raw.github.com/${REPOSITORY_NAME}/master/$FILE" -O ~/$FILE
}

for f in $FILES; do
	first_car=`echo $f | awk '{print substr($0,0,1)}'`
	if [ "$first_car" = "." ]; then
		if [ -f ~/$f ]; then
			read -p "~/$f already exists, overwrite it ? (y/n) : " update
			if [ "$update" = "y" ]; then
				update_dotfile $f
			else
				echo "Skipping $f."
			fi
		else
			update_dotfile $f
		fi
	fi
done