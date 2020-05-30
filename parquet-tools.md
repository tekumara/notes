# Parquet tools

https://github.com/apache/parquet-mr/tree/master/parquet-tools

## Install

`brew install parquet-tools`

##  Build from source

```
git clone https://github.com/apache/parquet-mr.git
cd parquet-mr
#checkout the latest tag (as using the SNAPSHOT requires building the whole project) 
git checkout apache-parquet-1.10.0
cd parquet-tools
mvn clean package -Plocal
```

##  Usage
```
pt="java -jar $(pwd)/target/parquet-tools-1.10.0.jar"

$pt schema <file>

$pt meta <file>

# show first record
$pt head -n1 <file>

# show all in json format
$pt cat -j <file>

# first example in json
$pt -j <file> | head -n1
```

To see row counts (RC):
```
$pt meta part-00016-2df55223-1b03-4eec-b330-a9d0c0adcfd6.c000.snappy.parquet
```

To see column stats:
```
$pt dump -d -n part-00016-2df55223-1b03-4eec-b330-a9d0c0adcfd6.c000.snappy.parquet | less

row group 0
--------------------------------------------------------------------------------
id:    INT64 SNAPPY DO:0 FPO:4 SZ:1594/3124/1.96 VC:385 ENC:BIT_PACKED,PLAIN
text:  BINARY SNAPPY DO:0 FPO:1598 SZ:788534/1433497/1.82 VC:385 ENC:BIT_PACKED,RLE,PLAIN_DICTIONARY

    id TV=385 RL=0 DL=0
    ----------------------------------------------------------------------------
    page 0:                          DLE:BIT_PACKED RLE:BIT_PACKED VLE:PLAIN ST:[min: 0, max: 385, num_nulls: 0] SZ:3080 VC:385

    text TV=385 RL=0 DL=1 DS: 336 DE:PLAIN_DICTIONARY
    ----------------------------------------------------------------------------
    page 0:                          DLE:RLE RLE:BIT_PACKED VLE:PLAIN_DICTIONARY ST:[no stats for this column] SZ:249 VC:237
    page 1:                          DLE:RLE RLE:BIT_PACKED VLE:PLAIN_DICTIONARY ST:[no stats for this column] SZ:180 VC:148
```

or just a specific column:
```
$pt dump -c suggestion_type -d -n part-00088-01edfdd3-0ee6-434f-b1b8-6c46460f5e1b-c000.snappy.parquet | head 
row group 0 
--------------------------------------------------------------------------------
suggestion_type:  BINARY SNAPPY DO:0 FPO:119756853 SZ:35025/40041/1.14 VC:251693 ENC:BIT_PACKED,PLAIN_DICTIONARY,RLE ST:[min: BatchPayment, max: RuleApplication, num_nulls: 226143]

    suggestion_type TV=251693 RL=0 DL=1 DS: 5 DE:PLAIN_DICTIONARY
    ----------------------------------------------------------------------------
    page 0:                                  DLE:RLE RLE:BIT_PACKED VLE:PLAIN_DICTIONARY ST:[min: BatchPayment, max: RuleApplication, num_nulls: 226143] SZ:39876 VC:251693

row group 1 
--------------------------------------------------------------------------------
```

[Meta legend](https://github.com/apache/parquet-mr/tree/master/parquet-tools#meta-legend):

`SZ:{x}/{y}/{z}`	Size in bytes. x = Compressed total, y = uncompressed total, z = y:x ratio

For each column:
`SZ` = uncompressed size. If this is dictionary encoded it shows the size of the pointers into the dictionary, otherwise shows the size of the raw values.  
`VC` = value count (the same as row count) 
`DS` = number of entries in the dictionary  
`PLAIN` = no dictionary  
`PLAIN_DICTIONARY` = encoded using a dictionary  
`RC` = row count (number of rows in the row group)



To see the size of the dictionary, use [parquet-cli](https://github.com/rdblue/parquet-cli)

