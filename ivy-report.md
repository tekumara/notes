# Ivy Report

The ivy report is the definitive record of how your project was resolved.

Ivy reports (when resolved from either IvyDE or ant) are stored in `%USERPROFILE%\.ivy2\cache`, eg: `%USERPROFILE%\.ivy2\cache\org.jamsim-jamsim-default.xml`

Download - indicates whether the artifact was downloaded by the resolution or not. If it was already in the cache then download = no.

## Casperdatasets-io ivy.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ivy-module version="2.0">

	<info organisation="net.casper" module="${name}" revision="${version}" status="release">
		<license name="LGPL" url="http://www.gnu.org/licenses/lgpl.html" />
		<description homepage="http://code.google.com/p/casperdatasets/">
			Casper datasets I/O modules for loading datasets to/from files
			and Java POJO beans.
		</description>
	</info>

	<configurations>
		<conf name="default" visibility="public" description="binary artifacts of this module and its dependencies"/>
		<conf name="sources" visibility="public" description="source artifacts of this module and its dependencies"/>
		<conf name="javadoc" visibility="public" description="javadoc artifacts of this module and its dependencies"/>
	</configurations>

	<publications>
		<artifact conf="default" />
		<artifact name="${name}-sources" type="source" conf="sources" ext="jar" />
		<artifact name="${name}-javadoc" type="javadoc" conf="javadoc" ext="jar" />
		<artifact type="pom" ext="pom" conf="default"/>
	</publications>

	<dependencies>
		<dependency org="net.casper" name="casperdatasets" rev="latest.integration" conf="*->@"/>
		<dependency org="org.omancode" name="omcutil" rev="latest.integration" conf="*->@"/>
		<dependency org="org.omancode" name="readmytables" rev="latest.integration" conf="*->@"/>
		<dependency org="org.omancode" name="readmytablesfromfiles" rev="latest.integration" conf="*->@"/>
        <dependency org="commons-lang" name="commons-lang" rev="latest.integration" conf="*->@"/>
        <dependency org="commons-beanutils" name="commons-beanutils" rev="latest.integration" conf="*->@">
        	<exclude name="commons-collections"/>
        </dependency>
        <dependency org="net.sourceforge.supercsv" name="supercsv" rev="latest.integration" />

		<!--  conf 1,2,3,5,6 produce no gson jar artifact. Only conf 4 works! -->

        <!-- conf 1
        <dependency org="com.google.code.gson" name="gson" rev="latest.integration" conf="*->default, master(*), compile(*), javadoc, runtime(*), sources"/>
        -->

        <!--  conf 2
        <dependency org="com.google.code.gson" name="gson" rev="latest.integration" conf="*->default, compile, runtime, master"/>
		-->

        <!--  conf 3
        <dependency org="com.google.code.gson" name="gson" rev="latest.integration" conf="*->default"/>
        -->

        <!--  conf 4
        <dependency org="com.google.code.gson" name="gson" rev="latest.integration" conf="default"/>
        -->

        <!-- conf 5
        <dependency org="com.google.code.gson" name="gson" rev="latest.integration" conf="*->@"/>
         -->

        <!-- conf 6 -->
        <dependency org="com.google.code.gson" name="gson" rev="latest.integration"/>

        <!-- exclude dependencies artifacts based on configuration -->
		<exclude type="source" ext="*" conf="master,javadoc"/>
		<exclude type="javadoc" ext="*" conf="master,sources"/>
		<exclude type="jar" ext="*" conf="sources,javadoc"/>

    </dependencies>
</ivy-module>
```

## Gson ivy.xml example

gson has the following configurations:

```xml
	<configurations>
		<conf name="default" visibility="public" description="runtime dependencies and master artifact can be used with this conf" extends="runtime,master"/>
		<conf name="master" visibility="public" description="contains only the artifact published by this module itself, with no transitive dependencies"/>
		<conf name="compile" visibility="public" description="this is the default scope, used if none is specified. Compile dependencies are available in all classpaths."/>
		<conf name="provided" visibility="public" description="this is much like compile, but indicates you expect the JDK or a container to provide it. It is only available on the compilation classpath, and is not transitive."/>
		<conf name="runtime" visibility="public" description="this scope indicates that the dependency is not required for compilation, but is for execution. It is in the runtime and test classpaths, but not the compile classpath." extends="compile"/>
		<conf name="test" visibility="private" description="this scope indicates that the dependency is not required for normal use of the application, and is only available for the test compilation and execution phases." extends="runtime"/>
		<conf name="system" visibility="public" description="this scope is similar to provided except that you have to provide the JAR which contains it explicitly. The artifact is always available and is not looked up in a repository."/>
		<conf name="sources" visibility="public" description="this configuration contains the source artifact of this module, if any."/>
		<conf name="javadoc" visibility="public" description="this configuration contains the javadoc artifact of this module, if any."/>
		<conf name="optional" visibility="public" description="contains all optional dependencies"/>
	</configurations>
```

Note that default extends runtime, master and runtime extends compile, so that if default is resolved then default,runtime,master,compile will all be resolved.

gson has the following artifacts:

```xml
		<artifact name="gson" type="jar" ext="jar" conf="master"/>
		<artifact name="gson" type="source" ext="jar" conf="sources" m:classifier="sources"/>
		<artifact name="gson" type="javadoc" ext="jar" conf="javadoc" m:classifier="javadoc"/>
```

## Ivy report of project dependent on gson

gson by com.google.code.gson

Revision: 2.1
|Home Page|http://code.google.com/p/google-gson/ |
|Status|release |
|Publication|00000000000000 |
|Resolver |public|
|Configurations |system, default, optional, compile, \*, provided, runtime, javadoc, sources, master |
|Artifacts |size 0 kB (0 kB downloaded, 0 kB in cache) |
|Licenses |The Apache Software License, Version 2.0 |

The ''Configurations'' section above indicates all the configurations of gson that are being requested by requirers + the base confs that any requested configurations extend.

NB: If a project depending on gson has no conf specified, eg:

```
<dependency org="com.google.code.gson" name="gson" rev="latest.integration">
```

and defaultconfmapping and defaultconf are also blank (the default), then the default `conf=_->_` is implied and all confs in gson ivy.xml are used (see [here](http://ant.apache.org/ivy//history/2.2.0/ivyfile/configurations.html#defaultconfmapping)). The dependency in casperdatasets-io ivy.xml looks like this.

**Required by**

| Organisation | Name              | Revision | In Configurations                                             | Asked Revision     |
| ------------ | ----------------- | -------- | ------------------------------------------------------------- | ------------------ |
| net.casper   | casperdatasets-io | 2.1.1    | default, master(_), compile(_), javadoc, runtime(\*), sources | latest.integration |

The `In Configurations` column indicates the master configurations, ie: the configuration of the requirer that appears on the left hand side of the configuration mapping (see [Configurations mapping](http://ant.apache.org/ivy//history/2.2.0/ivyfile/dependency.html), eg: in casperdatasets-io the master configuration is `default, master(_), compile(_), javadoc, runtime(_), sources` (ie: probably \_).

**Dependencies**

`No dependency`

**Artifacts**

`No artifact`

No artifacts are being returned because configurations //default, compile, master(_), runtime, compile(_), javadoc, runtime(_), master, sources// are all being resolved at once, ''and there is an exclude directive'' in casperdatasets-io ivy.xml. We can see from the ''Required by'' section that casperdatasets-io is the culprit because it is using master configurations //master, javadoc, and source.// which if we look the casperdatasets-io dependency on gson (//conf="_->\*"//) maps every master configuration to everything. We'll need to make a change here, or possibly further up the tree at the top level that is requesting //master, javadoc, source// all at the same time. We can find the top level by looking at what requires casperdatasets-io, which is casperdatasets-ext:

```
<dependency org="net.casper" name="casperdatasets-io" rev="latest.integration" force="true" conf="compile->compile(*),master(*);runtime->runtime(*)"/>
```

here casperdatasets-ext will map to \* if compile and master don't exist. In casperdatasets-io we have only //default, sources, javadoc// so compile will map to all of these.
