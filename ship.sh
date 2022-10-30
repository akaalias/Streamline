#!/usr/bin/env zsh

# abort on errors
set -e

# build
# npm run build

echo -n "My commit message: "
read MESSAGE

echo $MESSAGE

git add -A
git commit -m $MESSAGE
git push origin main
