# wget

Download to /tmp with filename
```
wget http://www.google.com -O /tmp/google.htm
```

Use provided filename, but place in /tmp
```
wget http://www.google.com -P /tmp
```

Download using filename provided in the content-disposition header rather than the URL:
```
wget --content-disposition http://lucidor.org/get.php\?id\=lucidor_0.9.10-1_all.deb
```

Overwrite if newer (may just always overwrite if there are no timestamps)
```
wget http://www.google.com -N
```

Download list of urls from a file:
```
wget -i /hd/2down.txt -c --no-check-certificate -P /hd
```

Additional options:

`-i` input file  
`-c` continue/resume  
`--no-check-certificate` don't validate the server's certificate  
