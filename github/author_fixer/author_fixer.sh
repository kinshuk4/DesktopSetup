#!/bin/sh

#Borrowed from https://stackoverflow.com/a/30737248/3222727

git filter-branch --env-filter '

OLD_EMAIL="your-old-email@example.com"
CORRECT_NAME="Your Correct Name"
CORRECT_EMAIL="kinshuk.ram@gmail.com"

if [ "$GIT_COMMITTER_EMAIL" != "$CORRECT_EMAIL" ]
then    
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" != "$CORRECT_EMAIL" ]
then    
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

