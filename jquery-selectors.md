# jQuery Selectors

`$("div")` - selects all `<div>` elements

`$(".ui-widget")` - all elements of class ui-widget

`$(".one .two")` - all elements of class two, that are descendants of elements that are class one

`$(".one, .two")` - all elements of class one + all elements of class two.

`$(".one.two")` - all elements that are of class one AND also of class two.

`$(".two", ".one")` - all elements of class two, that are descendants of elements that are class one, ie: the same as $(".one .two"). Known as selector context. (Selector context is implemented with the .find() method; therefore, $( "li.item-ii" ).find( "li" ) is equivalent to $( "li", "li.item-ii" ) [ref](http://api.jquery.com/find/))

`$('[data-reactid]')` - all elements with a data-reactid attribute

`$(':not([data-reactid])')` - all elements without a data-reactid attribute

`$(''[data-src]:not([src])')` - all elements with a data-src attribute and no src attribute

`$('[data-reactid=".0"]')` - all elements with attribute data-reactid = ".0"

`$('[data-href-large]').map(function () { return $(this).attr('data-href-large') });` - get an array of 'data-href-large' attributes from all elements with a data-href-large attribute
