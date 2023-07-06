# task-multiuser
## What is this?

This is my attempt at making taskwarrior accessible across multiple users. I'm
aware that taskserver exists, but that's a heavy-handed solution. I just wanted
something simple and portable, and this seems to do the job.

Note that this is not by any means a serious project. It may have security or
usability issues I'm not aware of. It probably has issues with race conditions.
This is mostly a fun experiment with Linux permissions, so don't try to use it
for something serious.

## How it works

First off, every new user by default gets a task config file in their home
folder (through `/etc/skel`). This config file sets the task data folder to
`/var/task`. This folder only be accessible to members of the group cyops. The
folder should be owned by `root:cyops`, with `770` permissions and the sticky
bit.

For security purposes, hooks can only be added by the root user. The folder
that is used for hooks is set to 750 permissions, so any hooks can be accessed,
but not modified.

In order to prevent any accidents from happening (all group members have write
access to the folder), a cronjob also exists to back the task data up. It uses
git to run a backup once a day. The git data is stored at `/var/task/gitbackup`
and is only writeable by the root user.
