# less

Flags/env var:

`-U` print control codes for special characters including backspaces, tabs (`^I`), carriage returns.  
`-N` toggle line numbers
`-X` leaves the text on screen when you quit less instead of clearing the terminal.  
`-i` enables smart case-insensitive searching: lowercase patterns ignore case; patterns with uppercase stay case-sensitive.
`-Ps` followed by a string changes the default (short) prompt to that string. Must be the last flag so it can be followed by a string.
`+F` tail a file.

When inside less:

`:n` move to next file
