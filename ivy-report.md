<div title="Ivy Report" creator="oman002" modifier="YourName" created="201203122122" modified="201808050141" tags="ivy" changecount="41">
<pre>The ivy report is the definitive record of how your project was resolved.

Ivy reports (when resolved from either IvyDE or ant) are stored in {{{%USERPROFILE%\.ivy2\cache}}}, eg: {{{%USERPROFILE%\.ivy2\cache\org.jamsim-jamsim-default.xml}}}

Download - indicates whether the artifact was downloaded by the resolution or not. If it was already in the cache then download = no.

!Casperdatasets-io ivy.xml
{{{
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;ivy-module version=&quot;2.0&quot;&gt;

	&lt;info organisation=&quot;net.casper&quot; module=&quot;${name}&quot; revision=&quot;${version}&quot; status=&quot;release&quot;&gt;
		&lt;license name=&quot;LGPL&quot; url=&quot;http://www.gnu.org/licenses/lgpl.html&quot; /&gt;
		&lt;description homepage=&quot;http://code.google.com/p/casperdatasets/&quot;&gt;
			Casper datasets I/O modules for loading datasets to/from files
			and Java POJO beans.
		&lt;/description&gt;
	&lt;/info&gt;

	&lt;configurations&gt;
		&lt;conf name=&quot;default&quot; visibility=&quot;public&quot; description=&quot;binary artifacts of this module and its dependencies&quot;/&gt;
		&lt;conf name=&quot;sources&quot; visibility=&quot;public&quot; description=&quot;source artifacts of this module and its dependencies&quot;/&gt;
		&lt;conf name=&quot;javadoc&quot; visibility=&quot;public&quot; description=&quot;javadoc artifacts of this module and its dependencies&quot;/&gt;
	&lt;/configurations&gt;

	&lt;publications&gt;
		&lt;artifact conf=&quot;default&quot; /&gt;
		&lt;artifact name=&quot;${name}-sources&quot; type=&quot;source&quot; conf=&quot;sources&quot; ext=&quot;jar&quot; /&gt;
		&lt;artifact name=&quot;${name}-javadoc&quot; type=&quot;javadoc&quot; conf=&quot;javadoc&quot; ext=&quot;jar&quot; /&gt;
		&lt;artifact type=&quot;pom&quot; ext=&quot;pom&quot; conf=&quot;default&quot;/&gt;
	&lt;/publications&gt;

	&lt;dependencies&gt;
		&lt;dependency org=&quot;net.casper&quot; name=&quot;casperdatasets&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;/&gt;
		&lt;dependency org=&quot;org.omancode&quot; name=&quot;omcutil&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;/&gt;
		&lt;dependency org=&quot;org.omancode&quot; name=&quot;readmytables&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;/&gt;
		&lt;dependency org=&quot;org.omancode&quot; name=&quot;readmytablesfromfiles&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;/&gt;
        &lt;dependency org=&quot;commons-lang&quot; name=&quot;commons-lang&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;/&gt;
        &lt;dependency org=&quot;commons-beanutils&quot; name=&quot;commons-beanutils&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;&gt;
        	&lt;exclude name=&quot;commons-collections&quot;/&gt;
        &lt;/dependency&gt;
        &lt;dependency org=&quot;net.sourceforge.supercsv&quot; name=&quot;supercsv&quot; rev=&quot;latest.integration&quot; /&gt;

		&lt;!--  conf 1,2,3,5,6 produce no gson jar artifact. Only conf 4 works! --&gt;

        &lt;!-- conf 1
        &lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;default, master(*), compile(*), javadoc, runtime(*), sources&quot;/&gt;
        --&gt;

        &lt;!--  conf 2
        &lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;default, compile, runtime, master&quot;/&gt;
		--&gt;

        &lt;!--  conf 3
        &lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;default&quot;/&gt;
        --&gt;

        &lt;!--  conf 4
        &lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot; conf=&quot;default&quot;/&gt;
        --&gt;

        &lt;!-- conf 5
        &lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot; conf=&quot;*-&gt;@&quot;/&gt;
         --&gt;

        &lt;!-- conf 6 --&gt;
        &lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot;/&gt;

        &lt;!-- exclude dependencies artifacts based on configuration --&gt;
		&lt;exclude type=&quot;source&quot; ext=&quot;*&quot; conf=&quot;master,javadoc&quot;/&gt;
		&lt;exclude type=&quot;javadoc&quot; ext=&quot;*&quot; conf=&quot;master,sources&quot;/&gt;
		&lt;exclude type=&quot;jar&quot; ext=&quot;*&quot; conf=&quot;sources,javadoc&quot;/&gt;

    &lt;/dependencies&gt;
&lt;/ivy-module&gt;
}}}


!Gson ivy.xml example

gson has the following configurations:
{{{
	&lt;configurations&gt;
		&lt;conf name=&quot;default&quot; visibility=&quot;public&quot; description=&quot;runtime dependencies and master artifact can be used with this conf&quot; extends=&quot;runtime,master&quot;/&gt;
		&lt;conf name=&quot;master&quot; visibility=&quot;public&quot; description=&quot;contains only the artifact published by this module itself, with no transitive dependencies&quot;/&gt;
		&lt;conf name=&quot;compile&quot; visibility=&quot;public&quot; description=&quot;this is the default scope, used if none is specified. Compile dependencies are available in all classpaths.&quot;/&gt;
		&lt;conf name=&quot;provided&quot; visibility=&quot;public&quot; description=&quot;this is much like compile, but indicates you expect the JDK or a container to provide it. It is only available on the compilation classpath, and is not transitive.&quot;/&gt;
		&lt;conf name=&quot;runtime&quot; visibility=&quot;public&quot; description=&quot;this scope indicates that the dependency is not required for compilation, but is for execution. It is in the runtime and test classpaths, but not the compile classpath.&quot; extends=&quot;compile&quot;/&gt;
		&lt;conf name=&quot;test&quot; visibility=&quot;private&quot; description=&quot;this scope indicates that the dependency is not required for normal use of the application, and is only available for the test compilation and execution phases.&quot; extends=&quot;runtime&quot;/&gt;
		&lt;conf name=&quot;system&quot; visibility=&quot;public&quot; description=&quot;this scope is similar to provided except that you have to provide the JAR which contains it explicitly. The artifact is always available and is not looked up in a repository.&quot;/&gt;
		&lt;conf name=&quot;sources&quot; visibility=&quot;public&quot; description=&quot;this configuration contains the source artifact of this module, if any.&quot;/&gt;
		&lt;conf name=&quot;javadoc&quot; visibility=&quot;public&quot; description=&quot;this configuration contains the javadoc artifact of this module, if any.&quot;/&gt;
		&lt;conf name=&quot;optional&quot; visibility=&quot;public&quot; description=&quot;contains all optional dependencies&quot;/&gt;
	&lt;/configurations&gt;
}}}
Note that //default// extends //runtime, master// and //runtime// extends //compile//, so that if //default// is resolved then //default,runtime,master,compile// will all be resolved.

gson has the following artifacts:
{{{
		&lt;artifact name=&quot;gson&quot; type=&quot;jar&quot; ext=&quot;jar&quot; conf=&quot;master&quot;/&gt;
		&lt;artifact name=&quot;gson&quot; type=&quot;source&quot; ext=&quot;jar&quot; conf=&quot;sources&quot; m:classifier=&quot;sources&quot;/&gt;
		&lt;artifact name=&quot;gson&quot; type=&quot;javadoc&quot; ext=&quot;jar&quot; conf=&quot;javadoc&quot; m:classifier=&quot;javadoc&quot;/&gt;
}}}

!Ivy report of project dependent on gson

!!!gson by com.google.code.gson
Revision: 2.1
|Home Page|http://code.google.com/p/google-gson/ |
|Status|release |
|Publication|00000000000000 |
|Resolver |public|
|Configurations |system, default, optional, compile, *, provided, runtime, javadoc, sources, master |
|Artifacts |size 0 kB (0 kB downloaded, 0 kB in cache) |
|Licenses |The Apache Software License, Version 2.0 |

The ''Configurations'' section above indicates all the configurations of gson that are being requested by requirers + the base confs that any requested configurations extend.

NB: If a project depending on gson has no conf specified, eg:
{{{
&lt;dependency org=&quot;com.google.code.gson&quot; name=&quot;gson&quot; rev=&quot;latest.integration&quot;&gt;
}}}
and defaultconfmapping and defaultconf are also blank (the default), then the default //conf=*-&gt;*// is implied and all confs in gson ivy.xml are used (see [[here|http://ant.apache.org/ivy//history/2.2.0/ivyfile/configurations.html#defaultconfmapping]]). The dependency in casperdatasets-io ivy.xml looks like this.

!!!Required by
|Organisation |Name| Revision |In Configurations |Asked Revision |
|net.casper |casperdatasets-io |2.1.1 |default, master(*), compile(*), javadoc, runtime(*), sources |latest.integration |

The ''In Configurations'' column indicates the master configurations, ie: the configuration of the requirer that appears on the left hand side of the configuration mapping (see [[Configurations mapping|http://ant.apache.org/ivy//history/2.2.0/ivyfile/dependency.html]], eg: in casperdatasets-io the master configuration is //default, master(*), compile(*), javadoc, runtime(*), sources// (ie: probably *).

!!!Dependencies
|No dependency  |

!!!Artifacts
|No artifact  |

No artifacts are being returned because configurations //default, compile, master(*), runtime, compile(*), javadoc, runtime(*), master, sources// are all being resolved at once, ''and there is an exclude directive'' in casperdatasets-io ivy.xml. We can see from the ''Required by'' section that casperdatasets-io is the culprit because it is using master configurations //master, javadoc, and source.// which if we look the casperdatasets-io dependency on gson (//conf=&quot;*-&gt;*&quot;//) maps every master configuration to everything. We'll need to make a change here, or possibly further up the tree at the top level that is requesting //master, javadoc, source// all at the same time. We can find the top level by looking at what requires casperdatasets-io, which is casperdatasets-ext:
{{{
&lt;dependency org=&quot;net.casper&quot; name=&quot;casperdatasets-io&quot; rev=&quot;latest.integration&quot; force=&quot;true&quot; conf=&quot;compile-&gt;compile(*),master(*);runtime-&gt;runtime(*)&quot;/&gt;
}}}
here casperdatasets-ext will map to * if compile and master don't exist. In casperdatasets-io we have only //default, sources, javadoc// so compile will map to all of these.</pre>
</div>
