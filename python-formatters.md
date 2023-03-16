# Python formatters

autopep8 makes the minimal changes required to make your code compliant with pep8.

black is much more aggressive, and enforces more than just pep8:

- changes [single quotes to double quotes](https://github.com/psf/black#strings)
- introduces more line breaks, eg: breaking out nested list comprehensions into multiple lines which make them arguably easier to read
- [add trailing commas](https://github.com/psf/black#trailing-commas) to multi-line expressions split by commas, including function signatures. This produces smaller diffs

Recommendation: use black.
