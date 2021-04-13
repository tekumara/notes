# make

A Makefile is a template, which is first read in and variable expansion/substitution is applied.

After expansion, one or more targets are executed. Each line in a target's recipe is a shell command that is executed inside its own shell.

Variable expansion happens first, so in this example `echo Hi` will never be executed.

```makefile
test:
    echo Hi
    $(error I died)
```

See:

- [How make Reads a Makefile](https://www.gnu.org/software/make/manual/html_node/Reading-Makefiles.html)
- [How do I write the 'cd' command in a makefile?](https://stackoverflow.com/a/1789616/149412)
- [Recipe Syntax](https://www.gnu.org/software/make/manual/html_node/Recipe-Syntax.html)

## Line prefixes

[Line prefixes](https://stackoverflow.com/questions/3477292/what-do-and-do-as-prefixes-to-recipe-lines-in-make):

- `-` ignore and continue if the command fails
- `@` suppresses the normal 'echo' of the command that is executed.

## Conditionals

eg: `ifeq`

"A conditional causes part of a makefile to be obeyed or ignored depending on the values of variables. Conditionals can compare the value of one variable to another, or the value of a variable to a constant string. Conditionals control what make actually "sees" in the makefile, so they cannot be used to control shell commands at the time of execution." [ref](http://kirste.userpage.fu-berlin.de/chemnet/use/info/make/make_7.html) [ref](https://stackoverflow.com/a/11994561/149412):

`ifdef` will be ignored if it appears after commands in a target,
eg: this works

```
foo:
    echo foo
baz = baz
ifdef noswap
    noswap-flag = --noswap
else
    noswap-flag =
endif

bar:
    echo "$(noswap-flag)"
```

this doesn't

```
foo:
    echo foo

ifdef noswap
    noswap-flag = --noswap
else
    noswap-flag =
endif

bar:
    echo "$(noswap-flag)"
```

"The if function provides support for conditional expansion in a functional context (as opposed to the GNU make makefile conditionals such as ifeq (see Syntax of Conditionals)."
[8.4 Functions for Conditionals](https://www.gnu.org/software/make/manual/html_node/Conditional-Functions.html#Conditional-Functions)

## Variable assignment

`VARIABLE = value` - lazy set, values within it are (recursively) expanded **everytime** the variable is used, not when it's declared.
`VARIABLE := value` - immediate set, values within it are expanded at declaration time

When you want "call" a variable with arguments, use `=`, eg:

```
check_contains = $(if $(findstring $2,$1),,$(error Expecting $2 in $1))
```

If you use `:=` then the result of the call will be empty string.

`define` is useful for defining multi-line variables, see [6.8 Defining Multi-Line Variables](https://www.gnu.org/software/make/manual/html_node/Multi_002dLine.html#Multi_002dLine)

See also:

- [The Two Flavors of Variables](https://www.gnu.org/software/make/manual/html_node/Flavors.html)
- [Variable Assignment](https://www.gnu.org/software/make/manual/html_node/Reading-Makefiles.html#Variable-Assignment)
- https://stackoverflow.com/a/448939/149412
- https://stackoverflow.com/a/30215530/149412

## Variable substitution

No difference between `$(var)` and `${var}`. Its recommended to be consistent. Note that `${var}` can be used in bash, whereas `$(var)` can't. [ref](https://stackoverflow.com/questions/25185607/whats-the-difference-between-parenthesis-and-curly-bracket-syntax-in-ma)

## Shell

Allows you to run shell commands and have their values stored in a variable, eg: `FILES:=$(shell ls)`

If using simple variables, eg: `FILES=$(shell ls)` note that shell will be executed every time `$(FILES)` is referenced [ref](https://electric-cloud.com/blog/2009/03/makefile-performance-shell/)

https://www.gnu.org/software/make/manual/html_node/Shell-Function.html

## Phony

If you want a target to be called regardless of if there is file with the target name in the same directory, use `.PHONY: mytarget` or `.PHONY: *` to make always execute all targets. https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html

## Comments

`#` marks a comment however variable expansion will still occur!

eg: `# $(FILES := $(shell ls))` will still execute `ls` even when commented!

## Target with % wildcard

`$*` will be replaced with the stem, ie: whatever `%` matches, eg:

```
# Check for specific environment variables
env-%:
    @ if [ "${${*}}" = "" ]; then \
        echo "Environment variable $* not set"; \
        exit 1; \
    fi

# -----------------------------------------
# Template creation

mappings-for-image: env-AWS_REGION env-IMAGE_ID
    mkdir -p build/
    printf "Mappings:\n  AWSRegion2AMI:\n    %s: { AMI: %s }\n" \
        "$(AWS_REGION)" $(IMAGE_ID) > build/mappings.yml
```

## String replacement

Patsubst matches whole words, eg: `$(patsubst %un,a,run something)` will resolve to `a something`

subst matches text occurences, eg: `$(subst u,a,run something)` will resolve to `ran something`

[Text-Functions](https://www.gnu.org/software/make/manual/html_node/Text-Functions.html)

## Eval

[Eval](https://www.gnu.org/software/make/manual/html_node/Eval-Function.html#Eval-Function) will parse its contents as Makefile syntax. Its useful for setting a variable from the result of a shell command within a target, eg:

```
time-one-min-ago:
    $(eval timemillis = $(shell echo "($$(date +%s)-(60))*1000" | bc))
    echo $(timemillis)
```

The shell command above only runs when the target is executed.

Alternatively, to perform a shell command only when a specific target runs (and not all targets), scope the variable definition to the target, eg:

```
time-one-min-ago: timemillis = $(shell echo "($$(date +%s)-(60))*1000" | bc)
time-one-min-ago:
    echo $(timemillis)
```

## Wildcards

Wildcards can be used to match a pattern to an explicit subdirectory level, eg:

```
# match match every file in `src` but not any subdirectories
src/*

# match match every file in `src` and the first level of subdirectories
src/*/*

# match every file in `src` and two levels of subdirectories
src/*/*/*

# recursively match all subdirectory levels, and also match hidden files
$(shell find src)
```

The wildcard function, eg: `$(wildcard src/*)` is the same as explicit wildcards, except for in the empty case. See [Pitfalls of Using Wildcards](https://www.gnu.org/software/make/manual/html_node/Wildcard-Pitfall.html#Wildcard-Pitfall)

## List all targets

```
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null  \
	| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
	| sort \
	| egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
```

## Debug

`make --just-print` just print the commands that would be executed

See [Chapter 12. Debugging Makefiles](https://www.oreilly.com/library/view/managing-projects-with/0596006101/ch12.html)

## Reference

[Index of Concepts](https://www.gnu.org/software/make/manual/html_node/Concept-Index.html)
[Heredoc in a Makefile](https://stackoverflow.com/questions/5873025/heredoc-in-a-makefile/7377522#7377522) - describes the use of the `.ONESHELL` target.
