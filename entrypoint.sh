#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

echo "Starting with UID : $USER_ID with secondary GUID : $GROUP_ID"

groupadd -f -g $GROUP_ID group
useradd --shell /bin/bash -u $USER_ID -G group -o -c "" -m user
export HOME=/home/user

echo "Secondary group: $(getent group lxd | cut -d: -f1)"
exec /usr/bin/gosu user "$@"