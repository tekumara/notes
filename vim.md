# Vim

## Arrow keys produce characters

Install Vim. Navigation in vi uses `hjkl`.

## Process vim buffer with shell command

To process the vim buffer using a shell command, eg:

`%!python -mjson.tool`

the leading % is a range specifier that many commands use. % is the whole buffer. You can do more selective ranges as well.

This will pipe the result back into the buffer.

## Navigation

`n` navigation mode  
`ctrl-f` scrolls down a page (think "F"orward)  
`ctrl-b` scrolls up a page (think "B"ack)  
`ctrl-d` scrolls down half a page  
`ctrl-u` scrolls up half a page  
`G` Jump to beginning of the last line of the file  
`Go` create a line after the last line of the file
`gg` Jump to start of file
`10, right arrow` move 10 chars to the right  
`b` move backward to the beginning of next word (NB: It's just a coincidence that `Alt + Left arrow` = `^[b` and therefore moves back a word, but with an alarm because of the `^[b`)
`w` move forward to the beginning of next word (NB: `Alt + Right arrow` is only move forward in emacs)
`:123<CR>` or `123G` goto line number 123  
`f` find a single character  
`;` repeat search  
`^` takes you to the beginning of a line, and `$` to the end  
`:set number` show line numbers
`:%s/foo/bar/g` find and replace 'foo' with 'bar' in all the lines.

http://vim.wikia.com/wiki/Moving_around

## Jumps

jump back: `ctrl o`
jump forward: `ctrl i`
jump to tag: `ctrl ]`

A tag is like a link. See `:h tag`.

You jump when you perform a search, or move around with marks, scroll block wise with braces, use % key... and when switching buffers.
See [vim doc jump-motions](http://vimdoc.sourceforge.net/htmldoc/motion.html#jump-motions)

## Mouse

Enable window resizing, moving between windows and tabs, and double-click to jump: `:set mouse=a`

## Multi-line paste

If a multi-line paste is appearing on a single line, or auto-indenting is being applied and alters the pasted text, enter paster mode first:

`:set paste` or
`,pp` if using amix/vimrc

[ConradIrwin/vim-bracketed-paste](https://github.com/ConradIrwin/vim-bracketed-paste) will automatically do this for you for terminals that support [bracketed paste mode](http://cirw.in/blog/bracketed-paste).

## Copy/cut paste

visual selection (by line) - `V`  
visual selection by column - `ctrl+V` - to replace, press `c`, type the replacement, and then press ESC  
select whole file - `ggVG` (gg moves to first line, V starts visual selection, G jumps to last line)  
copy - `y`  
copy to system clipboard - `"*y`  
copy line - `yy`  
cut line - `dd`  
paste before - `P`  
paste after - `p`  
paste before from system clipboard - `"*p`  
reindent - `=` - this will deindent if the indentation is incorrect.
indent - `>` to ident again, press `.` (redo)
comment - ctrl+V to select visually the first column, then shift+i, #, esc
`o` in normal mode: Create new line below current, enter insert mode.

`ciw` to replace the word under the cursor ([ref](https://stackoverflow.com/questions/1379198/how-to-delete-a-word-and-go-into-insert-mode-in-vim))

To paste in the middle on a line at the current cursor position, enter insert mode, and press Ctrl-R to paste the unnamed buffer.

### Clipboard registers



The default clipboard register in Vim is the **unnamed register `"`** (double quote).

When you yank or delete without specifying a register:

- `yy` → copies to `"` register
- `dd` → cuts to `"` register
- `p` → pastes from `"` register

This is separate from the system clipboard registers (`+` and `*`) unless you set `clipboard=unnamedplus`, which makes the unnamed register sync with the `+` (system clipboard) register.

To see what's in the unnamed register:

```vim
:reg "
```

In Vim/Neovim, `*` and `+` are special clipboard registers:

`+` register (clipboard):

- The system clipboard (Ctrl+C/Ctrl+V on Linux/Windows, Cmd+C/Cmd+V on macOS)
- Used for copying/pasting between applications

`*` register (primary selection):

- X11/Linux primary selection (middle-click paste)
- On Windows/macOS, often mapped to the same as `+`
- Automatically populated when you select text with the mouse

On macOS both `\*` and `+` typically point to the same system clipboard (pasteboard), so they're functionally identical.

On Linux (X11):

- `+` = Ctrl+C/Ctrl+V clipboard
- `*` = Select text + middle-click paste (primary selection)

### Unnamedplus

`unnamedplus` is a Vim/Neovim clipboard option that automatically uses the system clipboard (`+` register) for all yank, delete, change, and put operations.


## File operations

open file: `:e <filename>`  
reload the current file: `:e`
close file without exiting: `:bd`  
save as `:w myfile.txt`

## Editing

undo: `u`
redo: `Ctrl-R` or `.`

## Insert

Insert the [escape character](http://en.wikipedia.org/wiki/Escape_character#ASCII_escape_character): 'ctrl' + 'v' + '['

Insert at the end of file - `<ESC>GA`

## Delete

delete to end of line - `dG`
delete whole file - :1,$d
delete previous word db
delete next word dw

## File encoding

vim can guess character encoding try `:set` and have look at fileencoding
On load, if the status bar says "converted" ....

## Show line ends

`:set list` to show special chars, eg: `$` for new lines, `^I` for tab
`:e ++ff=unix` to show carriage returns as `^M` (reopens dos file in unix format). Oor start vim in binary mode, eg: `vim -b`.  
`:set nolist` to go back to normal.
`:set ff` to see file type in status bar (eg: unix, dos)

[ref](https://stackoverflow.com/questions/3860519/see-line-breaks-and-carriage-returns-in-editor#comment23046314_3860537)

## Vim buffers

Each file opened is stored in memory in a buffer.

`:ls` or `:buffers` to list buffers/opened files
`:b1` switch split to buffer 1
`:bd` delete buffer (aka close file)
`:enew` open new buffer in a new tab

See [Easier buffer switching](https://vim.fandom.com/wiki/Easier_buffer_switching)

## Vim Splits/Windows

Horizontal slipt `:sp filename`  
Move to bottom split `ctrl w down-arrow`  
Move to top split `ctrl w up-arrow`  
Move to next split `ctrl w w`

Resize horizontal split with the mouse or `ctrl w +` and `ctrl w -`

Help `:help usr_08`

Open a new tabpage `:tab`

[ref](https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally)

## Options

`:set all` list options  
`:set rtp?` see the value of the `rtp` (runtimepath) option
`:set bg=dark` better color scheme  
`:set nowrap` disable word wrapping

## Config

`:echo $USER` show the value of the USER env var
