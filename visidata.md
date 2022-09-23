# [visidata](https://github.com/saulpw/visidata)

Command line CSV viewer

Navigation

- `enter` open sheet
- `q` exit sheet
- `zr` goto row number

Copy

- `y` copy row to the Memory sheet
- `zy` copy cell to the Memory sheet
- `Y` copy row as tsv to system clipboard
- `zY` copy cell to system clipboard

- `/` forward search rows by regex applied to current column
- `?` backward search rows by regex applied to current column
- `g/` search rows by regex applied to all visible columns

Selection:

- `,` select rows matching display value of current cell in current column
- `gu` unselect all rows
- `|` select rows by regex applied to current column
- `g|` select rows by regex applied to all visible columns
- `"` open duplicate sheet with only selected rows

Column width:

- `_` toggle width of current column between full and default width
- `-` hide current column
- `z_` set column width
- `gv` unhide all columns
- `C` open Column Sheet. `e` to edit column width, set to 0 to hide.

Sheets:

- `S` jump between sheets or join them together

Sort:

- `[` or `]` sorts [rows](https://www.visidata.org/docs/rows/) ascending/descending by current column

[Stats / summaries](https://jsvine.github.io/intro-to-visidata/basics/summarizing-data/):

- `F` frequency table for current column
- sum column:
  1. `#` cast column to integer
  1. `z+sum`
  1. Check status bar at bottom of the screen

Misc

- `v` word wrap
- `i` add column with row number

See [Quick Reference Guide](https://www.visidata.org/man/)

Clipboard behaviour can be [configured](https://github.com/saulpw/visidata/issues/98).

The status line can be configured to [show the current row number](https://github.com/saulpw/visidata/issues/1536)

Wishlist

- [Bookmarks](https://github.com/saulpw/visidata/issues/1537)
