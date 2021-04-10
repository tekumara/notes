<div title="OS X Install R using brew" creator="YourName" modifier="YourName" created="201401211457" modified="201401221248" tags="R brew OSX" changecount="9">
<pre>{{{
brew tap homebrew/science
brew install gfortran
brew install r
}}}

If required, you will need to install the XQuartz from https://xquartz.macosforge.org

To enable rJava run:
{{{
R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
}}}

If you get a ''ld: library not found for -lint'' error, run this then try again:

{{{ln -s /usr/local/Cellar/gettext/0.18.3.2/lib/libintl.* /usr/local/lib/}}}

([[ref|https://github.com/Homebrew/homebrew-science/issues/627]])</pre>
</div>
