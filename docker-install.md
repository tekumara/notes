<div title="Docker Install Ubuntu" creator="YourName" modifier="YourName" created="201710160322" modified="201811162347" changecount="12">
<pre>The Ubuntu repos have a {{{docker-ce}}} package but it isn't typically the latest version, so use the docker repo

{{{
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   &quot;deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable&quot;
sudo apt-get install docker-ce
}}}









Install using convenience script ([[ref|https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-convenience-script]])
{{{
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker `whoami`
}}}


</pre>
</div>
