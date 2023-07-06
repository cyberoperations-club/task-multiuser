#!/bin/bash

# The path to the folder where taskwarrior data will be stored.
TASKPATH=/var/task
# The group that should have access to taskwarrior data.
TASKGROUP=cyops

if [ "$EUID" -ne 0 ]; then
    echo "The setup script must be run as root. Exiting."
    exit
fi

# Checks if TASKGROUP exists and, if it does not, creates it.
getent group $TASKGROUP || groupadd $TASKGROUP

# Creates task data folder.
mkdir $TASKPATH

chown root:$TASKGROUP $TASKPATH
chmod 770 $TASKPATH

# Adds the sticky bit, so TASKGROUP members can create files within the
# directory, but can't delete unless they're the owners. Required to
# make task edit work.
chmod o+t $TASKPATH

cd $TASKPATH

# Creates the data files used by taskwarrior with proper permissions.
touch backlog.data completed.data pending.data undo.data
chmod 660 {backlog.data,completed.data,pending.data,undo.data}
chown root:$TASKGROUP {backlog.data,completed.data,pending.data,undo.data}

# Prevents users from creating hooks.
mkdir hooks
chmod 750 hooks
chown root:$TASKGROUP hooks

# Creates the backup.
git init
mv .git gitbackup
# Makes backup only accessible to root.
chmod 700 gitbackup
chown root:root gitbackup
