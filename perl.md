# Perl

Command line options:

`-e` execute a oneliner  
`-n` do something to every line  
`-p` do something to every line, like -n, but also print the line  

Print first match
```
perl -ne 'if (/stopped: (.*?) seconds/) {print "$1\n";}' /app/tomcat/tcinst1/logs/catalina.out | head
```

Strip out lines that aren't numbers
```
cat listing-ids.txt | perl -ne 'if (/^[0-9]+$/){print;}' 
```

Extract the values of the key lastUpdated from lines of JSON
```
cat extract.json |perl -ne 'if(/lastUpdated/){s/^.*lastUpdated\":\"([^"]+).*$/\1/; print;}'
```

Extract unique 'JIRA-dddd':
```
cat /tmp/commits | perl -ne 'if (/(JIRA-[0-9]+)/){print "$1\n";}' | sort | uniq
```


If JIRA-dddd can appear multiple times in a line:
```
cat /tmp/commits | perl -ne 'while (/(JIRA-[0-9]+)/g){print "$1\n";}' | sort | uniq
```

NB:
`print $1 . "\n"` is the same as print `"$1\n"`

Duplicate each line into second column
```
cat business_names_sorted.txt| perl -ne 'chomp;print "$_|$_\n"'
```

Print out data.csv, replacing every occurrence of a 4 digit number with NUM
```
perl -pe 's/[0-9]{4}\b/NUM/g' data.csv
```

To do a inplace replace, saving a backup to *.bak
```
perl -i'*.bak' -pe 's/[0-9]{4}\b/NUM/g' data.csv
```

To process more than one regex at a time in a one-line, separate by ;
```
 perl -i'*.bak' -pe 's/\s+[0-9]{11}\b//;s/V5457 [0-9\/]{5} //' $1
```

Replace newline with \n literal
```
perl -pe 's/\n/\\n/'
```

Lowercase everything
```
 perl -pe "s/(.*)/lc($1)/e"
```

Print done if all lines in the last column are "done"
```
cat /tmp/recovery.resp | awk -F" " '{print $NF}' | perl -ne '$total++;$count++ if $_ =~ /done/; END { if ($total>0 and $total == $count) { print "done\n" } }'
```

Split on comma into a separate line
```
cat csv | perl -pe 's/,/\n/g'
```

Split and increment number
```
echo "402.0 KiB blahblah/partition=1/part-10000.parquet" | perl -ne '/^.*\s([^\s]+=)(\d+)(\/part-[^\s]+)$/; printf "%s%s%s,%s%d%s\n", $1,$2,$3,$1,$2+1, $3'
# blahblah/partition=1/part-10000.parquet,blahblah/partition=2/part-10000.parquet
```

Replace number (eg: foobar1 -> foobar2) using a capture group. Requires wrapping the capture group with `{}` 
```
printf "foobar1" | perl -pe 's/(foobar)1/${1}2/'
```


## Multiline processing

`-n` and `-p` assume a `while (<>) { ... }` loop around your program, which means regex expressions operate line by line

To operate on multiple lines, keep state between lines, eg:
```
$SEEN_X=1 if /previous_line_match/;
if $SEEN_X and /target_line_match/ {replace}
$SEEN_X=0;
```

Or modify the EOL character

## Docs

```
sudo apt-get install perl-doc
perldoc toc
```

Command line options: `perldoc perlrun`


