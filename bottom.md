# bottom

[bottom](https://github.com/ClementTsang/bottom) groups processes by name, and aggregates their sys stats like memory. This is useful for multi-process programs (eg: Chrome, VS Code).

## General

`e` - expand/collapse current widget

## Processes widget

`tab` - toggle grouping on/off
`m` - sort by memory. On Mac OS, this is the same as "Real Mem" in Activity Monitor.
`%` - toggle between values and percentages for the Mem column.
`P` - toggle between process name and full command.
`/` - toggle search panel, use `memb>100000000` to filter to processes with more than 100MiB NB: this filters at the individual process level, not at the aggregate level.

## memory

Using [sysinfo](https://blog.guillaume-gomez.fr/articles/2021-09-06+sysinfo%3A+how+to+extract+systems%27+information) to calculate memory.
