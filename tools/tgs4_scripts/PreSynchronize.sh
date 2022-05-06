#!/bin/sh

has_python="$(command -v python3)"
has_git="$(command -v git)"
has_sudo="$(command -v sudo)"
has_pip="$(command -v pip3)"

set -e

if ! { [ -x "$has_python" ] && [ -x "$has_pip" ] && [ -x "$has_git" ]; }; then
    echo "Installing dependencies..."
    if [ -x "$has_sudo" ]; then
        sudo dnf install -y python3-pip git
    else
        dnf install -y python3-pip git
    fi
fi

echo "Installing pip dependencies..."
if [ -x "$has_sudo" ]; then
	sudo pip3 install PyYaml beautifulsoup4
else
	pip3 install PyYaml beautifulsoup4
fi

cd $1

echo "Running changelog script..."
python3 tools/ss13_genchangelog.py html/changelogs

echo "Committing changes..."
git add html

#we now don't care about failures
set +e
git commit -m "Automatic changelog compile, [ci skip]"
exit 0
