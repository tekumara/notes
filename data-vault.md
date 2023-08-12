# Data Vault

## What?

OLTP data models are optimised for writes, and OLAP models are optimised for reads.

Data Vault optimises for auditability and automation of many sources. It standardises sources into hubs, sats, and links.

## Why?

Auditability - a record of every change in the source is kept, which enables auditing of derived values.
Automation - by normalising everything into the same shape it makes it quick to add new sources.

BUT there is quite a bit of complexity to handle the edge cases, which then gets forced onto the general case. If you have simple cases the complexity of Data Vault may not be worth it.

## DV 2.0

Insert only. Any change in state happens only by adding a row to a satellite table (ie: sat tables are type 2)
