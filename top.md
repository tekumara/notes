# Top

## BSD (macOS) top

- sort by CPU: `ocpu` or `top -o cpu`
- sort by mem (physical mem, aka rsize): `omem` or `top -o mem`

## GNU top

While top is running:

- save current state to ~/.toprc: `W`
- sort by %MEM: `M`
- sort by %CPU: `P`
- show individual CPU usage:`1`
- toggle between showing the process name and the command line: `c` (To see more of the command line, increase the size of the terminal window.)
- to select column to sort by: `shift-f`
- to filter processes to those with "java" in the command column `o, COMMAND=java`

NB:

- if you want this to include the command line args toggle that first
- it only filters on the visible part of the command line args, not everything

From the command line:

- to show only processes containing "elastic": `top -c -p $(pgrep -d',' -f elastic)`

## See also

Pidstat is a little like top’s per-process summary, but prints a rolling summary instead of clearing the screen, eg: `pidstat 1`

[bottom](bottom.md) will show real mem, unlike top. It can also group processes together with the same name, which is super useful. Press `e` to full screen the current widget. `tab` to group processes together and `m` to toggle sort by memory, and `%` to toggle between values and percentages.
