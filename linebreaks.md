# Line breaks

## Detect line breaks

Carriage returns will appear as ^M in git diffs. Use `file filename` to detect type of file, eg:

Legacy mac files:

```
ASCII text, with CR line terminators
```

Windows/DOS/PC files:

```
Unicode text, UTF-8 text, with CRLF line terminators
```

Unix files:

```
aws-ec2.md: Unicode text, UTF-8 text
```

To convert dos (ie: \r\n) to unix line breaks:

```
perl -pi -e 's/\r\n/\n/g' filename
```

Alternatively [use vim](http://stackoverflow.com/questions/811193/how-to-convert-the-m-linebreak-to-normal-linebreak-in-a-file-opened-in-vim/811208#811208)
