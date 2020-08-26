# Ubuntu user management

Create a new user with a disable password: `sudo adduser --disabled-password --gecos $username $username`

See what groups the user oliver user is in: `cat /etc/group | grep oliver`  
Create a new user called sat: `sudo adduser sat`  
Add sat to admin groups: `sudo usermod -a -G adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare sat`  
Remove user and their home directory: `sudo deluser --remove-home oliver`

Disable users by [expiring the account](https://askubuntu.com/questions/282806/how-to-enable-or-disable-a-user) (so even login via ssh key is disabled).
