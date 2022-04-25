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

- `/` search rows by regex applied to current column
- `g/` search rows by regex applied to all visible columns

Selection:

- `,` select rows matching display value of current cell in current column
- `gu` unselect all rows
- `|` select rows by regex applied to current column
- `g|` select rows by regex applied to all visible columns
- `"` open duplicate sheet with only selected row

Column width:

- `_` toggle width of current column between full and default width
- `-` hide current column
- `z_` set column width
- `gv` unhide all columns
- `C` open Column Sheet. `e` to edit column width, set to 0 to hide.

Sheets:

- `S` jump between sheets or join them together

Data

- `F` frequency table for current column
- `[` or `]` sorts [rows](https://www.visidata.org/docs/rows/) ascending/descending by current column

Misc

- `v` word wrap

See [Quick Reference Guide](https://www.visidata.org/man/)

Clipboard behaviour can be [configured](https://github.com/saulpw/visidata/issues/98).
