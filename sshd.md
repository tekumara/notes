<div title="SSH server Ubuntu" creator="YourName" modifier="YourName" created="201710312228" modified="201802240852" changecount="9">
<pre>{{{sudo apt install openssh-server}}}

To enable login via public key:
{{{
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
}}}

To add authorized keys to your user account on the remote host see [[SSH connection without password]]

!Config

Config in {{{/etc/ssh/sshd_config}}}. The commented out lines indicate what the default is, eg: {{{#PubkeyAuthentication yes}}} means PubkeyAuthentication is on.

To see config options:{{{man sshd_config}}}
Restart after changing config: {{{sudo systemctl restart sshd.service}}}

[[ref|https://help.ubuntu.com/lts/serverguide/openssh-server.html]]

To disable password login for a user, so they must use a publickey, add the following ([[ref|https://serverfault.com/a/285844/126276]]):
{{{
Match User david-bowie
    PasswordAuthentication no
}}}

!Logging

Auth logs go to  {{{/var/log/auth.log}}} including a fingerprint of any key that was used (see example and more details [[here|https://serverfault.com/a/291768/126276]])

Logins:
{{{
grep -Ei 'sshd.*(password|key)' /var/log/auth.log &amp;&amp;zgrep -Ei 'sshd.*(password|key)' /var/log/auth*.gz
}}}

Failed logins:
{{{
grep -Ei 'invalid|failed' /var/log/auth.log &amp;&amp; zgrep -Ei 'invalid|failed' /var/log/auth*.gz
}}}</pre>
</div>