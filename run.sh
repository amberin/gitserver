#! /bin/sh

set -x

if [ -d git/repo.git ]; then
  # Run garbage collection
  cd git/repo.git && git gc
  cd
else
  mkdir git/repo.git &&
    cd git/repo.git &&
      git init --bare
  cd
fi

if ! [ -f hostkeys/ed25519 ]; then
  ssh-keygen -q -N "" -t ed25519 -f hostkeys/ed25519
fi

echo "$AUTHORIZED_KEYS" > .ssh/authorized_keys

sshd -t -f sshd_config &&
  exec /usr/sbin/sshd -D -e -f sshd_config
