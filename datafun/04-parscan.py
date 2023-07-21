"""
SELECT * FROM CUSTOMER

but parallel

"""
from multiprocessing import Process

class Customer:
    pass

def read_customers(path: str) -> list[Customer]:
    pass


def scan():
    for c in read_customers("file1.parquet"):
        print(c)

p = Process(target=scan)
p.start()
p.join()

# How do we get batches?

# Memory complexity? O(B*P)


