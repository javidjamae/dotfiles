#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables
# dotfiles directory
dir=~/dotfiles
# old dotfiles backup directory
olddir=~/dotfiles_old

# list of files/folders to symlink in homedir
files="bash_profile bash_prompt bashrc gvimrc.after inputrc vimrc.after vimrc.before"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    target=~/.$file
    # Skip if already symlinked correctly
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$dir/$file" ]; then
        echo "$file is already symlinked correctly. Skipping."
        continue
    fi
    # Back up real files (not symlinks) before replacing
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up ~/.$file to $olddir"
        mv "$target" "$olddir/"
    fi
    echo "Creating symlink to $file in home directory."
    ln -sf "$dir/$file" "$target"
done

########## bin scripts
echo "Installing ~/bin scripts..."
mkdir -p ~/bin
for script in $dir/bin/*; do
    name=$(basename "$script")
    ln -sf "$script" ~/bin/"$name"
    chmod +x "$script"
    echo "  Linked ~/bin/$name"
done

########## LaunchAgents (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Installing LaunchAgents..."

    # rumps is required for the menu bar app
    if ! python3 -c "import rumps" 2>/dev/null; then
        echo "  Installing rumps..."
        pip3 install rumps --quiet
    fi

    mkdir -p ~/Library/LaunchAgents
    for template in $dir/launchagents/*.plist.template; do
        name=$(basename "$template" .template)
        dest=~/Library/LaunchAgents/"$name"
        # unload first in case it's already registered
        launchctl unload "$dest" 2>/dev/null
        # substitute placeholders (launchd can't expand variables)
        PYTHON3_PATH=$(which python3)
        sed -e "s|__HOME__|$HOME|g" -e "s|__PYTHON3__|$PYTHON3_PATH|g" "$template" > "$dest"
        launchctl load "$dest"
        echo "  Loaded $name"
    done
fi
