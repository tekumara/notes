"""
SELECT * FROM CUSTOMER JOIN ORDERS ON C_CUSTKEY=O_CUSTKEY;
"""
from typing_extensions import Self


class Customer:
    custkey: str
    def __lt__(self, c: Self) -> bool:
        pass

class Order:
    custkey: str
    def __lt__(self, c: Self) -> bool:
        pass


def read_customers(path: str) -> list[Customer]:
    pass

def read_orders(path: str) -> list[Order]:
    pass


def main():
    for c in read_customers("cust1.parquet"):
        for o in read_orders("order1.parquet"):
            if o.custkey==c.custkey:
                print(c,o)

    hashes = {}

    # build
    for c in read_customers("cust1.parquet"):
        hashes[c.custkey] = c

    # probe
    for o in read_orders("order1.parquet"):
        print(c[o.custkey],o)



main()

# Memory complexity?

# File bigger than mem?

