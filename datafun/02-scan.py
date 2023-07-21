"""
SELECT * FROM CUSTOMER
"""
from typing import Iterator


class Customer:
    pass


def read_next(path: str) -> Iterator[Customer]:
    pass

def main():
    for c in read_next("cust1.parquet"):
        print(c)

main()


# Memory complexity?

# IO?

# Batch for IO efficiency, but means more memory



