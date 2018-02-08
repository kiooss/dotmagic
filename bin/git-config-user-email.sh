#!/usr/bin/env bash

remote=`git remote -v | awk '/\(push\)$/ {print $2}' | cut -d ':' -f 1`
# default user and email
name="Yang Yang"
email=kiooss@gmail.com

# work email
if [[ $remote == 'git' ]]; then
  if [[ -z $WORK_EMAIL ]]; then
    echo "Please set your WORK_EMAIL env first."
    exit
  fi
  email=$WORK_EMAIL
fi

echo "Configuring user.name as $name & user.email as $email"
git config user.name "$name"
git config user.email "$email"
