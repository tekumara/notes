"""
SELECT * FROM CUSTOMER ORDER BY C_NAME
"""
from typing_extensions import Self


class Customer:
    def __lt__(self, c: Self) -> bool:
        pass

def read_customers(path: str) -> list[Customer]:
    pass

def scan():
    for c in sorted(read_customers("file1.parquet")):
        print(c)

scan()


# Memory complexity? O(n)

# File bigger than mem?




