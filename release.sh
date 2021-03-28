#!/usr/bin/env bash
set -e

read -p "This will reset your current working tree to origin/develop, is this okay? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git fetch
    git reset --hard origin/develop

    echo "Creating the release branch"
    mvn gitflow:release-start -DpushRemote=true

    echo "Merging the release branch into develop & master, pushing changes, and tagging new version off of master"
    mvn gitflow:release-finish -DpushRemote=true

    echo "Checking out latest version of master."
    git fetch
    git checkout origin/master

    echo "Deploying new release artifacts to sonatype repository."
    mvn clean deploy -P release

fi
