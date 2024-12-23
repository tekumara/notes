# AceMoney

## ASB

OFX MS Money

## CBA Netbank

Use CSV so we can reorder transactions to match the UI.

using duckdb:

```sql
CREATE TEMP TABLE ace AS SELECT * FROM read_csv_auto ('csvdata.csv');

.mode csv
.headers on
# nb this will overwrite the file
.once csvdata.duck.csv

select '' as Num,strftime(column0, '%d/%m/%Y') as Date,column2 as Payee,'' as Category,'' as S,
  case when column1::numeric(18,2)<0 then abs(column1::numeric(18,2)) else '' end as Withdrawal,
  case when column1::numeric(18,2)>0 then column1 else '' end as Deposit,
  column3 as Total,
  '' as Comment
from ace order by rowid desc;
```

using sqlite:

```sql
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

From a View Transactions extract (file.csv) using duckdb

```sql

# create table so we have a rowid
CREATE TEMP TABLE file AS SELECT * FROM read_csv_auto ('file.csv');

.mode csv
.headers on
# nb this will overwrite the file
.once file.ace.csv

with trans as (select strptime(column1, '%d %b %Y') as Date
      , column2 as "Transaction Details"
      , cast(replace(replace(column3, ',',''), ' ','') as DECIMAL(18,2)) as Amount
      , cast(replace(replace(column4, ',',''), ' ','') as DECIMAL(18,2)) as Total
from file order by rowid desc)
select
  null as Num,strftime(Date, '%d/%m/%Y') as Date,
  "Transaction Details" as Payee,null as Category,null as S,
  case when Amount<0 then abs(Amount) else null end as Withdrawal,
  case when Amount>0 then Amount else null end as Deposit,
  Total,
  null as Comment
from trans;
```

## BankWest

Export CSV and use duckdb to reverse order the transactions so the balance matches the UI:

```sql
CREATE TEMP TABLE ace AS SELECT * FROM read_csv_auto ('Transactions_*.csv');

.mode csv
.headers on
-- nb this will overwrite the file
.once transactions.ace.csv

select '' as Num,strftime("Transaction Date", '%d/%m/%Y') as Date,Narration as Payee,'' as Category,'' as S,
  abs(Debit) as Withdrawal,
  Credit as Deposit,
  Balance as Total,
  '' as Comment
from ace order by rowid desc;
```

## St George

Export CSV (nb: set the UI to order from oldest to latest).

using duckdb:

```sql
CREATE TEMP TABLE ace AS SELECT * FROM read_csv_auto ('trans211224.csv');

.mode csv
.headers on
-- nb this will overwrite the file
.once trans.ace.csv 

select '' as Num,strftime(Date, '%d/%m/%Y') as Date,
  regexp_replace(
    -- format by stripping out leading transaction type and using it as a comment bellow
    regexp_replace(
      Description, '^(Visa Purchase( O/Seas)?|Visa Credit( Overseas)?|Osko Withdrawal|Osko Deposit|Sct Deposit|Eftpos Debit|Eftpos Credit|Tfr Wdl BPAY Internet|Atm Withdrawal( -Wbc)?)\s+\S+\s',''
    ),
    -- normalise by striping out trailing reference numbers
    '\d{4,}$', ''
  ) as Payee,
  '' as Category,'' as S,
  Debit as Withdrawal,
  Credit as Deposit,
  Balance as Total,
  regexp_extract(
      Description, '^(Visa Purchase( O/Seas)?|Visa Credit( Overseas)?|Osko Withdrawal|Osko Deposit|Sct Deposit|Eftpos Debit|Eftpos Credit|Tfr Wdl BPAY Internet|Atm Withdrawal( -Wbc)?)'
  ) as Comment
from ace
order by rowid asc;
```

## NAB

~/Dropbox/scripts/cnab ~/Downloads/Transactions.qif

## Downloads

By default, Acemoney will not have access to the Downloads Folder on macOS. Grant access via Security & Privacy - Full Disk Access.

## Run AceMoney on Linux

```
env WINEPREFIX="/home/tekumara/.wine" wine .wine/drive_c/Program\ Files\ \(x86\)/AceMoney/AceMoney.exe`
```

## Troubleshooting

> There is no Windows program configured to open this type of file

When opening a file from Finder with Acemoney, this error will occur if the file has a space in the name.
