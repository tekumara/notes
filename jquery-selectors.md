<div title="jQuery Selectors" creator="YourName" modifier="YourName" created="201408011058" modified="201504190248" tags="CSS jQuery" changecount="12">
<pre>{{{$(&quot;div&quot;)}}} - selects all &lt;div&gt; elements

{{{$(&quot;.ui-widget&quot;)}}} - all elements of class ui-widget

{{{$(&quot;.one .two&quot;)}}} - all elements of class two, that are descendants of elements that are class one

{{{$(&quot;.one, .two&quot;)}}} - all elements of class one + all elements of class two.

{{{$(&quot;.one.two&quot;)}}} - all elements that are of class one AND also of class two.

{{{$(&quot;.two&quot;, &quot;.one&quot;)}}} - all elements of class two, that are descendants of elements that are class one, ie: the same as $(&quot;.one .two&quot;). Known as selector context. (Selector context is implemented with the .find() method; therefore, $( &quot;li.item-ii&quot; ).find( &quot;li&quot; ) is equivalent to $( &quot;li&quot;, &quot;li.item-ii&quot; ) [[ref|http://api.jquery.com/find/]])

{{{$('[data-reactid]')}}} - all elements with a data-reactid attribute

{{{$(':not([data-reactid])')}}} - all elements without a data-reactid attribute

{{{$(''[data-src]:not([src])')}}} - all elements with a data-src attribute and no src attribute

{{{$('[data-reactid=&quot;.0&quot;]')}}} - all elements with attribute data-reactid = &quot;.0&quot;

{{{$('[data-href-large]').map(function () { return $(this).attr('data-href-large') });}}} - get an array of 'data-href-large' attributes from all elements with a data-href-large attribute</pre>
</div>
