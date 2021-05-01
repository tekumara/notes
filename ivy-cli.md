<div title="Ivy CLI" creator="YourName" modifier="YourName" created="201804120734" tags="Ivy" changecount="1">
<pre>Using Ivy to download an artifact and all its dependencies
{{{
sudo apt-get install ivy
java -jar /usr/share/java/ivy-2.3.0.jar -dependency org.apache.hadoop hadoop-aws 2.8.1 -retrieve &quot;lib/[artifact]-[revision](-[classifier]).[ext]&quot;
}}}
[[ref|https://stackoverflow.com/a/15456621/149412]]</pre>
</div>
