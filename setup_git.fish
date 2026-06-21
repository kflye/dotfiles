#!/usr/bin/env fish

set source (realpath (dirname (status --current-filename))/git/.gitignore)
set target "$HOME/.gitignore"

if test -e "$target"; or test -L "$target"
    if test (realpath "$target" 2>/dev/null) = "$source"
        echo "$target already links to $source"
        exit 0
    end

    echo "$target already exists and does not link to $source" >&2
    exit 1
end

ln -s "$source" "$target"
echo "Linked $target -> $source"
