#!/bin/bash

#TODO: log failures

# The path to the folder where taskwarrior data will be stored.
TASKPATH=/var/task

git --git-dir="$TASKPATH/gitbackup" \
    --work-tree="$TASKPATH" \
    --all --message "$(date '+%Y-%m-%d')"
