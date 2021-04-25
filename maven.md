<div title="Maven usage" creator="YourName" modifier="Oman" created="201209230328" modified="201306200559" tags="maven" changecount="13">
<pre>!mvn commands

mvn help:effective-pom
mvn -V # show version
mvn install -DskipTests=true


!List dependencies

mvn dependency:tree
mvn dependency:list

NB:
* When mvn dependency:tree errors use mvn dependency:list
* mvn dependency:tree is not correct in Maven 3 - see [[this|https://cwiki.apache.org/MAVEN/maven-3x-compatibility-notes.html#Maven3.xCompatibilityNotes-DependencyResolution]]

=&gt; prefer mvn dependency:list

[[maven-dependency-plugin|https://maven.apache.org/plugins/maven-dependency-plugin/index.html]]</pre>
</div>
