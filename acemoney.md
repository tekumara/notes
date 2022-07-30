# AceMoney

## CBA Netbank

Use CSV so we can reorder the transactions.

rm csvdata.ace.csv

```
CREATE TABLE "csvdata" (
  "Date" TEXT,
  "Amount" TEXT,
  "Payee" TEXT,
  "Balance" TEXT
);
.mode csv
.import csvdata.csv csvdata

.headers on
# nb this will append to the file
.once csvdata.ace.csv

# order desc so balance is correct
select "" as Num,Date,Payee,"" as Category,"" as S,iif(cast(Amount as decimal)<0,abs(cast(Amount as decimal)),"") as Withdrawal,iif(cast(Amount as decimal)>0,Amount,"") as Deposit,Balance as Total,"" as Comment from csvdata order by rowid desc;
```

## Downloads

By default, Acemoney will not have access to the Downloads Folder on macOS. Grant access via Security & Privacy - Full Disk Access.

## Run AceMoney on Linux

`env WINEPREFIX="/home/tekumara/.wine" wine .wine/drive_c/Program\ Files\ \(x86\)/AceMoney/AceMoney.exe`
```
