# ssh keygen

`ssh-keygen -lf ~/.ssh/id_rsa` shows you the public sha256 fingerprint of the key in the file `~/.ssh/id_rsa`. If this is a RSA/DSA private key it will look for the .pub file.
`ssh-keygen -c -f ~/.ssh/id_rsa` update the comment on the key. The comment appears in `ssh-add -l`.
`ssh-keygen -y -f ~/.ssh/id_rsa` read private key, print public key. Will always prompt for a passphrase regardless of whether it has been loaded in ssh-agent (if the key has one).
