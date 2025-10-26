# parallel

## Xargs

xargs does not group output from parallel processes, which can cause output from different processes to be interleaved. This means parts of a line may come from different processes, making the output difficult to read.

## GNU parallel

The most featureful implementation, but has a nag message that needs to be acknowledged before it goes away.

Use `--tty` to write to a tty to preserve colors if the command doesn't have a color flag.

See [parallel_alternatives - Alternatives to GNU parallel](https://www.gnu.org/software/parallel/parallel_alternatives.html).

## moreutils parallel

A simplified version of parallel, shipped with [moreutils](https://manpages.debian.org/testing/moreutils/parallel.1.en.html).

Also know as Tollef parallel after the author.

## Rush

Has support for regex grouping matching.

## Examples

Diff of all changes

```sh
# Using gnu parallel
find work -mindepth 2 -maxdepth 2 -type d |
   parallel -j4 'git -C {} diff --color'

# Using rush
find work -mindepth 2 -maxdepth 2 -type d |
   rush -j4 'git -C {} diff --color'

# Using xargs - nb: doesn't group output, but writes ansi colors to tty
find work -mindepth 2 -maxdepth 2 -type d -print0 |
   xargs -0 -n1 -P4 -I{} git -C "{}" diff
```

Open all changes files in vscode

```sh
# Using gnu parallel
find work -mindepth 2 -maxdepth 2 -type d |
   parallel -j4 'git -C {} diff --name-only 2>/dev/null | sed "s|^|{}/|"' | xargs code

# Using xargs - nb: doesn't group output, but writes ansi colors to tty
find work -mindepth 2 -maxdepth 2 -type d -print0 |
   xargs -0 -n1 -P4 -I{} sh -c 'git -C "$1" diff --name-only 2>/dev/null | sed "s|^|$1/|" ' _ {} | xargs code
```
