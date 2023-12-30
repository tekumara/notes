# unicode

Here is a quick summary of the key differences in the Unicode standard:

- Code point - A number that represents an atomic element of Unicode text. Often a visible symbol, but may also represent aspects such as a [letter accent](https://en.wikipedia.org/wiki/Combining_Diacritical_Marks) or emoji skin tone. Represented as U+XXXX.
- Code unit - Encode code points as bytes for storage or transmission. A code point may consist of one or more code units. UTF-8 and UTF-16 are encodings that store code points in code units of 8 and 16 bits respectively. UTF-8 has the nice property that the code points from U+0000 -> U+0127 as stored as a single byte and mimic ASCII.
- Grapheme cluster - A single user-visible graphical unit of text. May consist of one or more code points. For example `न्` is perceived as a single consonant in Hindi but consists of two Unicode characters - U+0928 (`न`) and U+094D (vowel sign). A grapheme may have multiple code point representations, eg: `é` is the single code point U+00E9 and `é` is the sequence U+0065 U+0301 (e + combining acute accent) - see [here](https://apps.timwhitlock.info/unicode/inspect?s=%C3%A9e%CC%81).
- Character - Roughly corresponds to grapheme but is somewhat ambiguous and depends on context.

## References

- [19 Unicode – a brief introduction (advanced)](https://exploringjs.com/impatient-js/ch_unicode.html)
- [The Unicode Standard: A Technical Introduction](https://unicode.org/standard/principles.html)
- [The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets (No Excuses!)](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses)
- [Unicode character inspector](https://apps.timwhitlock.info/unicode/inspect)
- [Character (computing) - Wikipedia](<https://en.wikipedia.org/wiki/Character_(computing)>)
- [What's the difference between a character, a code point, a glyph and a grapheme?](https://stackoverflow.com/a/27331885/149412)
- [Graphemes](https://www.johndcook.com/blog/2015/03/01/graphemes/) and [Grapheme Cluster Boundaries](https://www.unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries)
