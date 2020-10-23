#! /bin/bash

while IFS=: read user pass uid gid full home shell
do
echo -e "$full
Pseudo \t $user
UID \t $uid
GID \t $gid
Home \t $home
Shell \t $shelln
------"
done < /etc/passwd